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
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    var userCurrentLocation: Location?
    var isEditingTask = false
    var taskItem: TaskItem?
    
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
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func populateTaskDataIfNeeded() {
        guard let taskItem = taskItem else { return }
        
        taskTitleTextField.text = taskItem.title
        taskDescriptionTextView.text = taskItem.taskDescription
        calendar.select(taskItem.dueDate)
        
        switch taskItem.priority {
        case "Low":
            selectPriorityStackView(lowPriorityStackView)
        case "Medium":
            selectPriorityStackView(evenPriorityStackView)
        case "High":
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
            showAlert(message: "Please enter a task title.")
            return
        }
        
        let taskDescription = taskDescriptionTextView.text ?? ""
        
        guard let dueDate = calendar.selectedDate else {
            showAlert(message: "Please select a due date.")
            return
        }
        
        // Determine priority
        let priority: String
        if lowPriorityStackView.layer.borderWidth > 0 {
            priority = "Low"
        } else if evenPriorityStackView.layer.borderWidth > 0 {
            priority = "Medium"
        } else if highPriorityStackView.layer.borderWidth > 0 {
            priority = "High"
        } else {
            priority = "Low"
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
        
        // Update or add the task item using CoreDataManager
        if isEditingTask {
            guard let taskItem = taskItem else { return }
            let locationReminder = taskItem.locationReminder
            CoreDataManager.shared.updateTaskItem(taskItem: taskItem, title: taskTitle, description: taskDescription, dueDate: dueDate, priority: priority, isCompleted: taskItem.isCompleted, isInProgress: taskItem.isInProgess,locationReminder: locationReminder)
            
            print(CoreDataManager.shared.fetchTaskItems())
        } else {
            
            CoreDataManager.shared.addTaskItem(title: taskTitle, description: taskDescription, dueDate: dueDate, priority: priority, isCompleted: isCompleted, locationReminder: locationReminder)
        }
        
        print("Due Date: \(dueDate)")
        
        NotificationManager.shared.scheduleNotificationAfterTwoMinutes(taskTitle: taskTitle, taskDescription: taskDescription)
        self.dismiss(animated: true)
    }
    
    
    @IBAction func didTapOnDeleteTask(_ sender: UIButton) {
        // Delete the task
        
        if let taskItem = taskItem {
            NotificationManager.shared.cancelNotification(identifier: taskItem.title ?? "")
            CoreDataManager.shared.deleteTaskItem(taskItem: taskItem)
        }
        self.dismiss(animated: true)
    }
    
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Tasky", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
