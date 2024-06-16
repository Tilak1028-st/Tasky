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
    @IBOutlet weak var createTaskButton: UIButton!
    @IBOutlet weak var oddPriorityView: UIView!
    @IBOutlet weak var lowPriorityView: UIView!
    @IBOutlet weak var evenPriorityView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    var userCurrentLocation: Location?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAddNewTaskView()
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.transitioningDelegate = self
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    private func setUpAddNewTaskView() {
        // Setup task description text view
        taskDescriptionTextView.applyBorder(color: UIColor.gray, width: 1)
        taskDescriptionTextView.applyCornerRadius(20)
        
        // Setup createTaskButton
        createTaskButton.applyCornerRadius(20)
        
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
        title = AppStringConstant.createTask
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
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
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
        selectPriorityStackView(selectedStackView)
    }
    
    @objc private func mapViewDidTapped(_ sender: UITapGestureRecognizer) {
        guard let mapSearchVc = storyboard?.instantiateViewController(identifier: AppStringConstant.mapSearchViewController) as? MapSearchViewController else { return }
        mapSearchVc.mapSearchDelegate = self
        mapSearchVc.currentSelectedLocation = userCurrentLocation
        navigationController?.pushViewController(mapSearchVc, animated: true)
    }
    
    private func selectPriorityStackView(_ selectedStackView: UIStackView) {
        // Reset all priority stack views
        lowPriorityStackView.layer.borderWidth = 0
        evenPriorityStackView.layer.borderWidth = 0
        highPriorityStackView.layer.borderWidth = 0
        
        // Highlight the selected stack view
        selectedStackView.layer.borderColor = UIColor.gray.cgColor
        selectedStackView.layer.borderWidth = 1
        selectedStackView.layer.cornerRadius = 20
    }
}

// MARK: - MapSearchViewControllerDelegate
extension AddNewTaskViewController: MapSearchViewControllerDelegate {
    func didSelectLocation(_ location: Location) {
        DispatchQueue.main.async {
            // Add an annotation for the selected location on the map
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.name
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(annotation)
            
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

// MARK: - UIViewControllerTransitioningDelegate
extension AddNewTaskViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
}
