//
//  LocationManager.swift
//  Weather
//
//  Created by Andrei Kornilov on 02.10.2021.
//

import CoreLocation

final class LocationManager: NSObject {
    static let shared = LocationManager()
    
    // MARK: Private Methods
    private let locationManagerCL = CLLocationManager()
    
    // MARK: Initialization
    private override init() {
        super.init()
        
        let storedLocations = StorageManager.shared.fetchLocations()
        
        if storedLocations.isEmpty {
            determineCurrentLocation()
        } else {
            WeatherManager.shared.fetchAllWeather(with: storedLocations)
        }
    }
}

// MARK: Private Methods
extension LocationManager {
    private func determineCurrentLocation() {
        locationManagerCL.delegate = self
        locationManagerCL.desiredAccuracy = kCLLocationAccuracyBest
        locationManagerCL.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManagerCL.startUpdatingLocation()
        }
    }
}


// MARK: CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { [weak self] places, error in
            guard let places = places, error == nil else {
                if let error = error {
                    print("Reverse Geocoder location error: \(error.localizedDescription)")
                }
                
                return
            }
            
            guard let place = places.first else { return }
            
            let userLocation = Location(coordinate: location.coordinate, place: place)
            StorageManager.shared.saveLocation(userLocation)
            
            self?.locationManagerCL.stopUpdatingLocation()
            self?.locationManagerCL.delegate = nil
            
            WeatherManager.shared.fetchAllWeather(with: [userLocation])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // If needed process errors
        // print("CLLLocationManager error: \(error.localizedDescription)")
    }
}

// MARK: Public Methods
extension LocationManager {
    func findLocations(with query: String, completion: @escaping (([Location]) -> Void)) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let locations: [Location] = places.compactMap { place in
                guard let coordinate = place.location?.coordinate else { return nil }
                let result = Location(coordinate: coordinate, place: place)
                
                return result
            }
            
            completion(locations)
        }
    }
}
