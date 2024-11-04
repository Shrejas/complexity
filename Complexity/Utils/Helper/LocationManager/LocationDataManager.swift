
//  LocationDataManager.swift
//  CoreLocationSwiftUITutorial
//
//  Created by Cole Dennis on 9/21/22.


import Foundation
import CoreLocation

class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var latitude: Double?
    @Published var longitude: Double?
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestManger() // Request location permissions when initializing
    }

    // Request location permission based on current authorization status
    func requestManger() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Location access was denied or restricted.")
            authorizationStatus = CLLocationManager.authorizationStatus()
        case .authorizedWhenInUse, .authorizedAlways:
            authorizationStatus = CLLocationManager.authorizationStatus()
            locationManager.startUpdatingLocation()
        @unknown default:
            // Handle any future authorization cases
            print("Unhandled authorization status.")
        }
    }

    func requestLocation() {
        // Ensure the location manager is set to request the location when in use
        if authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func requestLocationStop() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        print("Updated location: \(latitude ?? 0.0), \(longitude ?? 0.0)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    func distanceBetweenLocations1(location: CLLocation) -> CLLocationDistance? {
        if let latitude = latitude, let longitude = longitude {
            let cL = CLLocation(latitude: latitude, longitude: longitude)
            return cL.distance(from: location)
        }
        return nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Call requestManger to handle authorization state changes
        requestManger()
    }
}
