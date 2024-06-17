//
//  AddNewTaskViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit
import FSCalendar
import MapKit
import CoreLocation
import IQKeyboardManagerSwift
import EventKit


struct Location {
    let name: String
    let coordinate: CLLocationCoordinate2D
}

protocol MapSearchViewControllerDelegate: AnyObject {
    func didSelectLocation(_ location: Location)
}

class AddNewTaskViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var taskTitleTextField: UnderlineTextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var priorityStackView: UIStackView!
    @IBOutlet weak var lowPriorityStackView: UIStackView!
    @IBOutlet weak var evenPriorityStackView: UIStackView!
    @IBOutlet weak var highPriorityStackView: UIStackView!
    @IBOutlet weak var deleteTaskButton: UIButton!
    @IBOutlet weak var createTaskButton: UIButton!
    @IBOutlet weak var oddPriorityView: UIView!
    @IBOutlet weak var lowPriorityView: UIView!
    @IBOutlet weak var evenPriorityView: UIView!
    @IBOutlet weak var timeTextField: UnderlineTextField!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    var userCurrentLocation: Location?
    var isEditingTask = false
    var taskItem: TaskItem?
    var originalTask: TaskItem?
    var timePicker: UIDatePicker!
    var selectedDateAndTime: Date?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAddNewTaskView()
        setupLocationManager()
        populateTaskDataIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.transitioningDelegate = self
        self.setupNavigationBar()
    }
    
    
    // MARK: - Setup Methods
    private func setUpAddNewTaskView() {
        // Setup task description text view
        taskDescriptionTextView.applyBorder(color: UIColor.gray, width: 1)
        taskDescriptionTextView.applyCornerRadius(20)
        taskDescriptionTextView.delegate = self
        
        // Setp TimeTextfield
        
        timeTextField.applyBorder(color: UIColor.gray, width: 1)
        timeTextField.applyCornerRadius(10)
        timeTextField.placeholder = AppStringConstant.selectTime
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = Locale(identifier: "en_US")
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        timeTextField.inputView = timePicker
        
        // Create a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // Set the toolbar as the accessory view for the UITextField
        timeTextField.inputAccessoryView = toolbar
        
        // Setup createTaskButton
        createTaskButton.applyCornerRadius(20)
        deleteTaskButton.applyCornerRadius(20)
        deleteTaskButton.isHidden = !isEditingTask
        
        // Setup priority views
        oddPriorityView.makeCircular()
        lowPriorityView.makeCircular()
        evenPriorityView.makeCircular()
        selectPriorityStackView(lowPriorityStackView)
        addTapGestureToStackView(lowPriorityStackView)
        addTapGestureToStackView(evenPriorityStackView)
        addTapGestureToStackView(highPriorityStackView)
        
        // Setup map view
        mapView.applyBorder(color: UIColor.gray, width: 1)
        mapView.applyCornerRadius(20)
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        addTapGestureToMapView(mapView)
        
        // Setup calendar
        calendar.scope = .month
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.todayColor = .appGreen
        calendar.appearance.selectionColor = .gray
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.applyBorder(color: UIColor.gray, width: 1)
        calendar.applyCornerRadius(20)
        calendar.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesUpperCase]
        
        // Setup title
        title = isEditingTask ? "Edit Task" : AppStringConstant.createTask
        
        // Disable inputs initially if editing
        if isEditingTask {
            disableInputs()
            createTaskButton.setTitle("Save Task", for: .normal)
        } else {
            enableInputs()
        }
    }
    
    private func setupNavigationBar() {
        // Set initial navigation bar appearance
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .appGreen
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.appGreen
        ]
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        setUpRightNavigationBarButton()
    }
    
    private func setUpRightNavigationBarButton() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: ImageConstant.xmarkCircleFill), style: .plain, target: self, action: #selector(rightButtonTapped))
        
        self.navigationItem.rightBarButtonItem = dismissButton
    }
    
    @objc func rightButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func timeChanged() {
        // Update the selectedDateAndTime with the date and time from the picker
        selectedDateAndTime = timePicker.date
        
        // Format the date and time and set it as the text of the UITextField
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeStyle = .short
        timeTextField.text = formatter.string(from: timePicker.date)
    }
    
    @objc func doneButtonTapped() {
        // Dismiss the picker when the Done button is tapped
        timeTextField.resignFirstResponder()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func populateTaskDataIfNeeded() {
        guard let taskItem = taskItem else { return }
        
        originalTask = taskItem
        
        taskTitleTextField.text = taskItem.title
        taskDescriptionTextView.text = taskItem.taskDescription
        calendar.select(taskItem.dueDate)
        selectedDateAndTime = taskItem.dueDate
        timePicker.date = taskItem.dueDate ?? Date()
        timeChanged()
        
        switch taskItem.priority {
        case AppStringConstant.low:
            selectPriorityStackView(lowPriorityStackView)
        case AppStringConstant.medium:
            selectPriorityStackView(evenPriorityStackView)
        case AppStringConstant.high:
            selectPriorityStackView(highPriorityStackView)
        default:
            selectPriorityStackView(lowPriorityStackView)
        }
        
        if let location = taskItem.locationReminder {
            let taskLocation = Location(name: location.reminderText ?? "", coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            userCurrentLocation = taskLocation
            setMapAnnotion(taskLocation)
        }
    }
    
    private func disableInputs() {
        taskTitleTextField.isUserInteractionEnabled = false
        taskDescriptionTextView.isUserInteractionEnabled = false
        lowPriorityStackView.isUserInteractionEnabled = false
        evenPriorityStackView.isUserInteractionEnabled = false
        highPriorityStackView.isUserInteractionEnabled = false
        calendar.isUserInteractionEnabled = false
        mapView.isUserInteractionEnabled = false
    }
    
    private func enableInputs() {
        taskTitleTextField.isUserInteractionEnabled = true
        taskDescriptionTextView.isUserInteractionEnabled = true
        lowPriorityStackView.isUserInteractionEnabled = true
        evenPriorityStackView.isUserInteractionEnabled = true
        highPriorityStackView.isUserInteractionEnabled = true
        calendar.isUserInteractionEnabled = true
        mapView.isUserInteractionEnabled = true
    }
    
    // MARK: - Gesture Setup
    private func addTapGestureToStackView(_ stackView: UIStackView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(priorityStackViewTapped(_:)))
        stackView.addGestureRecognizer(tapGesture)
    }
    
    private func addTapGestureToMapView(_ mapView: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewDidTapped(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func priorityStackViewTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedStackView = sender.view as? UIStackView else { return }
        enableInputs() // Enable inputs on interaction
        selectPriorityStackView(selectedStackView)
    }
    
    @objc private func mapViewDidTapped(_ sender: UITapGestureRecognizer) {
        guard let mapSearchVc = storyboard?.instantiateViewController(identifier: AppStringConstant.mapSearchViewController) as? MapSearchViewController else { return }
        mapSearchVc.mapSearchDelegate = self
        mapSearchVc.currentSelectedLocation = userCurrentLocation
        navigationController?.pushViewController(mapSearchVc, animated: true)
    }
    
    private func selectPriorityStackView(_ selectedStackView: UIStackView) {
        enableInputs() // Enable inputs on interaction
        // Reset all priority stack views
        lowPriorityStackView.layer.borderWidth = 0
        evenPriorityStackView.layer.borderWidth = 0
        highPriorityStackView.layer.borderWidth = 0
        
        // Highlight the selected stack view
        selectedStackView.layer.borderColor = UIColor.gray.cgColor
        selectedStackView.layer.borderWidth = 1
        selectedStackView.layer.cornerRadius = 20
    }
    
    @IBAction func didTapOnCreateTask(_ sender: UIButton) {
        // Validate task title
        guard let taskTitle = taskTitleTextField.text, !taskTitle.isEmpty else {
            showAlert(message: AppStringConstant.pleaseEnterTaskTitle)
            return
        }
        
        let taskDescription = taskDescriptionTextView.text ?? ""
        
        guard let dueDate = calendar.selectedDate else {
            showAlert(message: AppStringConstant.pleaseSelectDueDate)
            return
        }
        
        // Merge the selected date and time
        guard let selectedDateAndTime = selectedDateAndTime else {
            showAlert(message: AppStringConstant.pleaseSelectDueTime)
            return
        }
        
        let calendar = Calendar.current
        let dueDateComponents = calendar.dateComponents([.year, .month, .day], from: dueDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedDateAndTime)
        var mergedComponents = DateComponents()
        mergedComponents.year = dueDateComponents.year
        mergedComponents.month = dueDateComponents.month
        mergedComponents.day = dueDateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        
        guard let mergedDate = calendar.date(from: mergedComponents) else {
            showAlert(message: "Failed to merge date and time.")
            return
        }
        
        // Determine priority
        let priority: String
        if lowPriorityStackView.layer.borderWidth > 0 {
            priority = AppStringConstant.low
        } else if evenPriorityStackView.layer.borderWidth > 0 {
            priority = AppStringConstant.medium
        } else if highPriorityStackView.layer.borderWidth > 0 {
            priority = AppStringConstant.high
        } else {
            priority = AppStringConstant.low
        }
        
        // Task completion status
        let isCompleted = false
        
        // Location reminder
        var locationReminder: LocationEntity? = nil
        if let userLocation = userCurrentLocation {
            // Create a LocationEntity object and assign to locationReminder
            locationReminder = LocationEntity(context: CoreDataManager.shared.context)
            locationReminder?.reminderText = userLocation.name
            locationReminder?.latitude = userLocation.coordinate.latitude
            locationReminder?.longitude = userLocation.coordinate.longitude
        }
        
        if isEditingTask {
            guard let taskItem = taskItem else { return }
            guard let originalTask = originalTask else { return }
            let locationReminder = locationReminder
            
            
            // Edit the existing reminder in the calendar
            if let eventIdentifier = taskItem.title {
                CalendarManager.shared.editEvent(originalTitle: originalTask.title ?? "", originalStartDate: originalTask.dueDate ?? Date(), originalNotes: originalTask.taskDescription, newTitle: taskTitle, newStartDate: mergedDate, newNotes: taskDescription, newLocation: CLLocation(latitude: locationReminder?.latitude ?? 0.0, longitude: locationReminder?.longitude ?? 0.0)) { success, error in
                    if success {
                        print(AppStringConstant.reminderUpdated)
                    } else {
                        print("Failed to update reminder: \(String(describing: error))")
                    }
                }
            }
            
            
            // Edit the existing notification
            NotificationManager.shared.editNotification(identifier: originalTask.title ?? "", newTaskTitle: taskTitle, newTaskDescription: taskItem.taskDescription ?? "", newDueDate: mergedDate)
            
            
            CoreDataManager.shared.updateTaskItem(taskItem: taskItem, title: taskTitle, description: taskDescription, dueDate: mergedDate, priority: priority, isCompleted: taskItem.isCompleted, isInProgress: taskItem.isInProgess, locationReminder: locationReminder)
            
        } else {
            // Add a new task item and get its eventIdentifier
            CoreDataManager.shared.addTaskItem(title: taskTitle, description: taskDescription, dueDate: mergedDate, priority: priority, isCompleted: isCompleted, locationReminder: locationReminder)
            
            // Add a new notification
            NotificationManager.shared.scheduleNotification(taskTitle: taskTitle, taskDescription: taskDescription, dueDate: mergedDate)
            
            // Add a new event to the calendar
            CalendarManager.shared.addEvent(title: taskTitle, dueDate: mergedDate, notes: taskDescription, location: CLLocation(latitude: locationReminder?.latitude ?? 0.0, longitude: locationReminder?.longitude ?? 0.0)) { success, text, error  in
                if success {
                    print(AppStringConstant.reminderAdded)
                } else {
                    print("Failed to add reminder: \(String(describing: error))")
                }
            }
            
            // Add a new location based reminder to the calendar
            CalendarManager.shared.addLocationReminder(title: taskTitle, notes: taskDescription, dueDate: mergedDate, priority: priority, location: CLLocation(latitude: locationReminder?.latitude ?? 0.0, longitude: locationReminder?.longitude ?? 0.0), radius: 100, proximity: .enter) { success, text, error  in
                if success {
                    print(AppStringConstant.reminderAdded)
                } else {
                    print("Failed to add reminder: \(String(describing: error))")
                }
            }
        }
        
        self.dismiss(animated: true)
    }
    
    
    @IBAction func didTapOnDeleteTask(_ sender: UIButton) {
        // Delete the task
        
        if let taskItem = taskItem {
            NotificationManager.shared.cancelNotification(identifier: taskItem.title ?? "")
            
            CalendarManager.shared.deleteEvent(title: taskItem.title ?? "", startDate: taskItem.dueDate ?? Date(), notes: taskItem.taskDescription) {success, error in
                if success {
                    print(AppStringConstant.reminderDeleted)
                } else {
                    print("Failed to add reminder: \(String(describing: error))")
                }
            }
            
            CoreDataManager.shared.deleteTaskItem(taskItem: taskItem)
        }
        self.dismiss(animated: true)
    }
    
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: AppStringConstant.tasky, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStringConstant.ok, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func setMapAnnotion(_ location: Location) {
        DispatchQueue.main.async {
            // Add an annotation for the selected location on the map
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.name
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(annotation)
            self.userCurrentLocation = location
            
            // Center the map on the selected location
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            self.mapView.setRegion(region, animated: true)
        }
    }
    
}

// MARK: - MapSearchViewControllerDelegate
extension AddNewTaskViewController: MapSearchViewControllerDelegate {
    func didSelectLocation(_ location: Location) {
        setMapAnnotion(location)
    }
}

// MARK: - CLLocationManagerDelegate
extension AddNewTaskViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            switch status {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                print(AppStringConstant.locationAccessDenied)
            case .authorizedWhenInUse, .authorizedAlways:
                manager.startUpdatingLocation()
            @unknown default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            guard let location = locations.first else { return }
            
            // Update user's current location and center the map
            self.userCurrentLocation = Location(name: AppStringConstant.currentLocation, coordinate: location.coordinate)
            let regionRadius: CLLocationDistance = 1000
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: regionRadius,
                longitudinalMeters: regionRadius
            )
            self.mapView.setRegion(region, animated: true)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            print("\(AppStringConstant.failedToFindUserLocation) \(error.localizedDescription)")
        }
    }
}

// MARK: - UITextViewDelegate
extension AddNewTaskViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension AddNewTaskViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
}
