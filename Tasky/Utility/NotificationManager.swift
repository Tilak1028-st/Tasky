//
//  NotificationManager.swift
//  Tasky
//
//  Created by Tilak Shakya on 16/06/24.
//

import Foundation
import UIKit
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationManager()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("Error requesting authorization: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotification(taskTitle: String, taskDescription: String, dueDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = taskTitle
        content.body = taskDescription
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotificationAfterTwoMinutes(taskTitle: String, taskDescription: String) {
           let content = UNMutableNotificationContent()
           content.title = taskTitle
           content.body = taskDescription
           content.sound = .default

           let triggerDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
           guard let triggerDateComponents = triggerDate else { return }
           
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerDateComponents.timeIntervalSinceNow, repeats: false)

           let identifier = UUID().uuidString
           let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

           UNUserNotificationCenter.current().add(request) { (error) in
               if let error = error {
                   print("Error scheduling notification: \(error.localizedDescription)")
               }
           }
       }

    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    // UNUserNotificationCenterDelegate methods

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
