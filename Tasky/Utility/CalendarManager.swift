//
//  CalendarManager.swift
//  Tasky
//
//  Created by Tilak Shakya on 17/06/24.
//

import Foundation
import EventKit
import CoreLocation

class CalendarManager {
    private let eventStore = EKEventStore()
    
    // Singleton instance
    static let shared = CalendarManager()
    
    private init() {
        // Register for EKEventStoreChanged notifications
        NotificationCenter.default.addObserver(self, selector: #selector(eventStoreChanged), name: .EKEventStoreChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func eventStoreChanged(notification: NSNotification) {
        // Handle changes in the event store
        print("Event store changed, refresh reminder data if needed.")
    }
    
    // Request access to calendar and reminders
    func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestAccess(to: .event) { (grantedEvent, errorEvent) in
            guard grantedEvent, errorEvent == nil else {
                completion(false, errorEvent)
                return
            }
            self.eventStore.requestAccess(to: .reminder) { (grantedReminder, errorReminder) in
                completion(grantedReminder, errorReminder)
            }
        }
    }
    
    // Check calendar and reminder authorization status
    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        let statusEvent = EKEventStore.authorizationStatus(for: .event)
        let statusReminder = EKEventStore.authorizationStatus(for: .reminder)
        
        if statusEvent == .authorized && statusReminder == .authorized {
            completion(true)
        } else if statusEvent == .notDetermined || statusReminder == .notDetermined {
            requestAccess { granted, _ in
                completion(granted)
            }
        } else {
            completion(false)
        }
    }
    
    // Add an event to the calendar with a one-hour duration
    func addEvent(title: String, dueDate: Date, notes: String?, location: CLLocation?, completion: @escaping (Bool, String?, Error?) -> Void) {
        checkAuthorizationStatus { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                let event = EKEvent(eventStore: self.eventStore)
                event.title = title
                event.startDate = dueDate
                event.endDate = dueDate.addingTimeInterval(3600) // Event duration is one hour
                event.notes = notes
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                
                if let location = location {
                    let structuredLocation = EKStructuredLocation(title: "Location")
                    structuredLocation.geoLocation = location
                    let alarm = EKAlarm()
                    alarm.structuredLocation = structuredLocation
                    alarm.proximity = .enter
                    event.addAlarm(alarm)
                }
                
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                    completion(true, event.eventIdentifier, nil)
                } catch let error {
                    completion(false, nil, error)
                }
            } else {
                let error = NSError(domain: "CalendarManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Access to calendar denied"])
                completion(false, nil, error)
            }
        }
    }
    
    // Helper method to find an event by title, start date, and notes
    private func findEvent(title: String, startDate: Date, notes: String?, completion: @escaping (EKEvent?) -> Void) {
        let endDate = startDate.addingTimeInterval(3600) // Assuming a one-hour duration for the event
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate)
        
        let filteredEvents = events.filter {
            $0.title == title && $0.notes == notes
        }
        
        completion(filteredEvents.first)
    }
    
    // Edit an existing event
    func editEvent(originalTitle: String, originalStartDate: Date, originalNotes: String?, newTitle: String, newStartDate: Date, newNotes: String?, newLocation: CLLocation?, completion: @escaping (Bool, Error?) -> Void) {
        checkAuthorizationStatus { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                self.findEvent(title: originalTitle, startDate: originalStartDate, notes: originalNotes) { event in
                    if let event = event {
                        event.title = newTitle
                        event.startDate = newStartDate
                        event.endDate = newStartDate.addingTimeInterval(3600) // Event duration is one hour
                        event.notes = newNotes
                        
                        // Update location-based alarm
                        if let newLocation = newLocation {
                            let structuredLocation = EKStructuredLocation(title: "Location")
                            structuredLocation.geoLocation = newLocation
                            let alarm = EKAlarm()
                            alarm.structuredLocation = structuredLocation
                            alarm.proximity = .enter
                            event.alarms = [alarm]
                        } else {
                            event.alarms = nil
                        }
                        
                        do {
                            try self.eventStore.save(event, span: .thisEvent)
                            completion(true, nil)
                        } catch let error {
                            completion(false, error)
                        }
                    } else {
                        let error = NSError(domain: "CalendarManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Event not found"])
                        completion(false, error)
                    }
                }
            } else {
                let error = NSError(domain: "CalendarManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Access to calendar denied"])
                completion(false, error)
            }
        }
    }
    
    // Delete an existing event
    func deleteEvent(title: String, startDate: Date, notes: String?, completion: @escaping (Bool, Error?) -> Void) {
        checkAuthorizationStatus { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                self.findEvent(title: title, startDate: startDate, notes: notes) { event in
                    if let event = event {
                        do {
                            try self.eventStore.remove(event, span: .thisEvent)
                            self.removeReminder(reminder: .init(eventStore: self.eventStore)) { isDeleted, error in
                                if error != nil {
                                    completion(false, error)
                                }
                            }
                            completion(true, nil)
                        } catch let error {
                            completion(false, error)
                        }
                    } else {
                        let error = NSError(domain: "CalendarManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Event not found"])
                        completion(false, error)
                    }
                }
            } else {
                let error = NSError(domain: "CalendarManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Access to calendar denied"])
                completion(false, error)
            }
        }
    }
    
    // Add a location-based reminder
    func addLocationReminder(title: String, notes: String?, dueDate: Date, priority: String, location: CLLocation, radius: Double, proximity: EKAlarmProximity, completion: @escaping (Bool, String?, Error?) -> Void) {
        checkAuthorizationStatus { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                guard let calendar = self.eventStore.defaultCalendarForNewReminders() else {
                    let error = NSError(domain: "CalendarManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Default reminders list not found"])
                    completion(false, nil, error)
                    return
                }
                
                let reminder = EKReminder(eventStore: self.eventStore)
                reminder.title = title
                reminder.calendar = calendar
                reminder.priority = getPriorityValue(priorityString: priority)
                reminder.notes = notes
                
                // Set due date and time
                let dueDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: dueDate)
                var combinedComponents = DateComponents()
                combinedComponents.year = dueDateComponents.year
                combinedComponents.month = dueDateComponents.month
                combinedComponents.day = dueDateComponents.day
                combinedComponents.hour = dueDateComponents.hour
                combinedComponents.minute = dueDateComponents.minute
                reminder.dueDateComponents = combinedComponents
                
                let structuredLocation = EKStructuredLocation(title: "Location")
                structuredLocation.geoLocation = location
                structuredLocation.radius = radius
                
                let alarm = EKAlarm()
                alarm.structuredLocation = structuredLocation
                alarm.proximity = proximity
                reminder.addAlarm(alarm)
                
                do {
                    try self.eventStore.save(reminder, commit: true)
                    completion(true, reminder.calendarItemIdentifier, nil)
                } catch let error {
                    completion(false, nil, error)
                }
            } else {
                let error = NSError(domain: "CalendarManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Access to reminders denied"])
                completion(false, nil, error)
            }
        }
    }
    
    // Fetch location-based reminders
    func fetchLocationReminders(completion: @escaping ([EKReminder]?, Error?) -> Void) {
        checkAuthorizationStatus { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate) { reminders in
                    guard let reminders = reminders else {
                        completion(nil, nil)
                        return
                    }
                    
                    let locationReminders = reminders.filter { reminder in
                        reminder.alarms?.contains(where: { alarm in
                            alarm.structuredLocation != nil && (alarm.proximity == .enter || alarm.proximity == .leave)
                        }) ?? false
                    }
                    
                    completion(locationReminders, nil)
                }
            } else {
                let error = NSError(domain: "CalendarManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Access to reminders denied"])
                completion(nil, error)
            }
        }
    }
    
    // Complete a reminder
    func completeReminder(reminder: EKReminder, completion: @escaping (Bool, Error?) -> Void) {
        checkAuthorizationStatus { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                reminder.isCompleted = true
                do {
                    try self.eventStore.save(reminder, commit: true)
                    completion(true, nil)
                } catch let error {
                    completion(false, error)
                }
            } else {
                let error = NSError(domain: "CalendarManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Access to reminders denied"])
                completion(false, error)
            }
        }
    }
    
    // Remove a reminder
    func removeReminder(reminder: EKReminder, completion: @escaping (Bool, Error?) -> Void) {
        checkAuthorizationStatus { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                do {
                    try self.eventStore.remove(reminder, commit: true)
                    completion(true, nil)
                } catch let error {
                    completion(false, error)
                }
            } else {
                let error = NSError(domain: "CalendarManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Access to reminders denied"])
                completion(false, error)
            }
        }
    }
    
    // Sort reminders by title
    func sortRemindersByTitle(reminders: [EKReminder]) -> [EKReminder] {
        return reminders.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }
    
    func getPriorityValue(priorityString: String) -> Int {
        switch priorityString.lowercased() {
        case "Low":
            return 0
        case "Medium":
            return 1
        case "High":
            return 2
        default:
            return 0
        }
    }
}
