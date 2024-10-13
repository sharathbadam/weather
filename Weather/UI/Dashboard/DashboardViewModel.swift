//
//  DashboardViewModel.swift
//  Weather
//
//  Created by Sharath on 10/10/24.
//

import Foundation
import Combine
import CoreLocation

class DashboardViewModel: NSObject, ObservableObject {
    @Published var searchQuery = ""
    @Published var searchResults: [GeoCode] = [] {
        didSet {
            showPopover = !searchResults.isEmpty
        }
    }
    @Published var selectedLocation: GeoCode?
    @Published var weather: WeatherResponse? {
        didSet {
            if let coordinates = weather?.coord, let lat = coordinates.lat, let lon = coordinates.lon {
                PersistanceManager.shared.saveCoordinates(latitude: lat, longitude: lon)
            }
        }
    }
    @Published var isLoading = false
    @Published var errorMsg: String?
    @Published var showPopover: Bool = false
    
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var location: CLLocation?

    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        $searchQuery
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                if let self {
                    
                    if let weather = weather, weather.name == query {
                        return
                    }
                    
//                    if let selectedLocation, selectedLocation.name == query {
//                        return
//                    }
                    guard !query.isEmpty else {
                        self.searchResults = []
                        return
                    }
                    self.searchForLocation(endpoint: Endpoint.geoCode(city: query))
                }
            }
            .store(in: &cancellables)
        
        let coordinates = PersistanceManager.shared.fetchCoordinates()
        if let latitude = coordinates.latitude, let longitude = coordinates.longitude {
            fetchWeatherReport(endpoint: Endpoint.geoCodeCoordinate(lat: latitude, lon: longitude))
        }
    }
    
    func searchForLocation(endpoint: Endpoint) {
        isLoading = true
        errorMsg = nil
        NetworkManager.shared.performRequest(endpoint: endpoint) { (result: Result<[GeoCode], NetworkError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let locations):
                    
                    self.searchResults = locations
                case .failure(let error):
                    self.searchResults = []
                    self.errorMsg = error.message
                }
            }
        }
    }
    
    func fetchWeatherReport(endpoint: Endpoint) {
        isLoading = true
        weather = nil
        self.errorMsg = nil
        NetworkManager.shared.performRequest(endpoint: endpoint) { (result: Result<WeatherResponse, NetworkError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let success):
                    self.weather = success
                    if let name = success.name, name.isEmpty == false {
                        self.searchQuery = name
                    } else if let coordinate = success.coord, let lat = coordinate.lat, let lon = coordinate.lon {
                        self.searchQuery = "\(lat), \(lon)"
                    }
                case .failure(let error):
                    self.errorMsg = error.message
                }
                
            }
        }
    }
    
    func selectLocation(location: GeoCode) {
        selectedLocation = location
        searchQuery = location.name
        searchResults = []  // Clear the results after selection
        fetchWeatherReport(endpoint: Endpoint.weatherReport(lat: location.lat, lon: location.lon))
    }
}

extension DashboardViewModel: CLLocationManagerDelegate {
    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            errorMsg = nil
            isLoading = true
            location = nil
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            errorMsg = NSLocalizedString("location_denitd", comment: "")
        @unknown default:
            errorMsg = NSLocalizedString("location_error", comment: "")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        if locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        DispatchQueue.main.async {
            self.isLoading = false
            self.location = locations.first
            
            self.fetchWeatherReport(endpoint: Endpoint.geoCodeCoordinate(lat: self.location?.coordinate.latitude ?? 0.0, lon: self.location?.coordinate.longitude ?? 0.0))
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        manager.stopUpdatingLocation()
        DispatchQueue.main.async {
            self.isLoading = false
//            self.errorMsg = "Failed to find user's location"
        }
    }
}

