//
//  MapSearchViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addSelectedLocationButton: UIButton!
    
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: ResultViewController())
    let locationManager = CLLocationManager()
    var currentSelectedLocation: Location?
    weak var mapSearchDelegate: MapSearchViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapSearchView()
    }
    
    // MARK: - Setup Methods
    private func setUpMapSearchView() {
        title = AppStringConstant.search
        addSelectedLocationButton.applyCornerRadius(20)
        
        // Configure search controller
        if let resultViewController = searchController.searchResultsController as? ResultViewController {
            resultViewController.delegate = self
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a location"
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.barTintColor = .appGreen
        searchController.searchBar.tintColor = .black
        searchController.searchBar.isTranslucent = false
        
        // Customize search bar text field
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.textColor = .black
            textField.tintColor = .black
        }
        
        // Embed the search bar into the navigation item
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Customize navigation bar appearance
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        self.navigationItem.hidesBackButton = true
        setUpRightNavigationBarButton()
        
        
        // Setup location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let currentLocation = currentSelectedLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = currentLocation.coordinate
            annotation.title = currentLocation.name
            mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(
                center: currentLocation.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func setUpRightNavigationBarButton() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: ImageConstant.xmarkCircleFill), style: .plain, target: self, action: #selector(rightButtonTapped))
        
        self.navigationItem.rightBarButtonItem = dismissButton
    }
    
    @objc func rightButtonTapped() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Actions
    @IBAction func didTapOnAddLocation(_ sender: Any) {
        DispatchQueue.main.async {
            self.mapSearchDelegate?.didSelectLocation(self.currentSelectedLocation ?? Location(name: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)))
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Compute region for the new location
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = AppStringConstant.currentLocation
            
            DispatchQueue.main.async {
                // Update the map view
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            print("Location manager error: \(error.localizedDescription)")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension MapSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return
        }
        performSearch(query: searchText)
    }
    
    private func performSearch(query: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            let search = MKLocalSearch(request: request)
            
            search.start { [weak self] response, error in
                guard let self = self else { return }
                
                if let error = error {
                    DispatchQueue.main.async {
                        print("\(AppErrorConstant.searchError) \(error.localizedDescription)")
                    }
                    return
                }
                
                guard let response = response else {
                    DispatchQueue.main.async {
                        print("\(AppErrorConstant.searchError) Unknown error")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    // Pass search results to ResultViewController
                    if let resultViewController = self.searchController.searchResultsController as? ResultViewController {
                        resultViewController.searchResults = response.mapItems
                    }
                }
            }
        }
    }
    
    private func showMapItem(_ mapItem: MKMapItem) {
        DispatchQueue.main.async {
            let annotation = MKPointAnnotation()
            self.currentSelectedLocation = Location(name: mapItem.name ?? "", coordinate: mapItem.placemark.coordinate)
            annotation.coordinate = mapItem.placemark.coordinate
            annotation.title = mapItem.name
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(
                center: mapItem.placemark.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            self.mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - ResultViewControllerDelegate
extension MapSearchViewController: ResultViewControllerDelegate {
    func didSelectMapItem(_ mapItem: MKMapItem) {
        DispatchQueue.main.async {
            self.showMapItem(mapItem)
            self.searchController.isActive = false
        }
    }
}

// MARK: - MapSearchDelegate
extension MapSearchViewController: MapSearchDelegate {
    func didPerformSearch(with mapItems: [MKMapItem]) {
        DispatchQueue.main.async {
            if let resultViewController = self.searchController.searchResultsController as? ResultViewController {
                resultViewController.searchResults = mapItems
            }
        }
    }
}

// MARK: - Custom Search Controller (Optional)
class CustomSearchController: UISearchController {
    override var searchBar: UISearchBar {
        let searchBar = super.searchBar
        searchBar.frame = CGRect(x: searchBar.frame.origin.x, y: searchBar.frame.origin.y, width: searchBar.frame.size.width, height: 150)
        return searchBar
    }
}
