
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
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func requestLocationStop() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    func distanceBetweenLocations1(location: CLLocation) -> CLLocationDistance? {
        if let latitude = latitude, let longitude  = longitude{
            let cL =  CLLocation(latitude: latitude, longitude:longitude)
            return cL.distance(from: location)
        }
        return nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break

        case .restricted:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .restricted
            break

        case .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .denied
            break

        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break

        default:
            break
        }
    }

    func requestManger(){
        if self.authorizationStatus == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
    }

}


