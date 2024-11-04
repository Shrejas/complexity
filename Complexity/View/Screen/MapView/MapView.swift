//
//  MapView.swift
//  Complexity
//
//  Created by IE14 on 30/04/24.

import Foundation
import SwiftUI
import GoogleMaps
import GooglePlaces

class MapData: ObservableObject {
    @Published var oldPin: [Place] = []
}

struct MapView: UIViewRepresentable {
    @ObservedObject var mapData: MapData
    var locationModel = LocationDataManager()
    @Binding var isDetailActive: Bool
    @Binding var isTapForLocationButton: Bool
    @Binding var placeId: String
    @Binding var locationCoordinate: CLLocationCoordinate2D?
    @Binding var locationCoordinate1: CLLocationCoordinate2D?
    @Binding var selected: PlaceMarker
    @State private var pinIsSet = true

    let locationManager = CLLocationManager()
    let mapView = GMSMapView()
    let googleClient: GoogleClientRequest = GoogleClient()

    func makeUIView(context: Context) -> GMSMapView {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        setMapViewPin()
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {

        var oldPin = [Place]()
        if locationCoordinate1 == nil {
            
            uiView.clear()
            
            if let newLocation = locationCoordinate {
                DispatchQueue.main.async {
                    let camera = GMSCameraPosition.camera(withLatitude: newLocation.latitude,
                                                          longitude: newLocation.longitude,
                                                          zoom: 14)
                    uiView.camera = camera
                }

                let searchedTypes = ["restaurant", "bar"]
                let dispatchGroup = DispatchGroup()

                for (index, type) in searchedTypes.enumerated() {
                    dispatchGroup.enter()
                    self.fetchNearbyRestaurants(location: newLocation, type: type) { result in
                        if index == 0 {
                            oldPin = result
                            DispatchQueue.main.async {
                                for place in oldPin {
                                    let placeMarker = PlaceMarker(place: place, type: searchedTypes[0])
                                    placeMarker.title = place.name
                                    placeMarker.map = uiView
                                }
                            }
                        } else {
                            let filteredArray = result.filter { !oldPin.contains($0) }
                            DispatchQueue.main.async {
                                for place in filteredArray {
                                    let placeMarker = PlaceMarker(place: place, type: searchedTypes[1])
                                    placeMarker.title = place.name
                                    placeMarker.map = uiView
                                }
                            }
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {}
            }
        } else if let newLocation = locationCoordinate1 {
            uiView.clear()
            
            DispatchQueue.main.async {
                let camera = GMSCameraPosition.camera(withLatitude: newLocation.latitude,
                                                      longitude: newLocation.longitude,
                                                      zoom: 13)
                uiView.camera = camera
            }
            
            let searchedTypes = ["restaurant", "bar"]
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            
            fetchPlaceDetails { result in
                DispatchQueue.main.async {
                    let type = result.types?.first ?? ""
                    let placeMarker = PlaceMarker(place: result, type: type)
                    placeMarker.title = result.name
                    placeMarker.map = uiView
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {}
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self, isTapForLocationButton: $isTapForLocationButton)
    }

    class MapViewCoordinator: NSObject, GMSMapViewDelegate, CLLocationManagerDelegate {
        var mapView: MapView
        @Binding var isTapForLocationButton: Bool
        
        init(_ mapView: MapView, isTapForLocationButton: Binding<Bool>) {
            self.mapView = mapView
            _isTapForLocationButton = isTapForLocationButton
            super.init()
        }

        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            // Handle map tap if needed
        }

        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            // Handle map idle event if needed
        }

        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if marker is PlaceMarker {
                self.mapView.selected = marker as! PlaceMarker
                self.mapView.isDetailActive = true
            }
            return true
        }

        func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
            print("isTapForLocationButton")
            isTapForLocationButton = true
            return true
        }

        func mapView(_ mapView: GMSMapView, didTapMyLocationButtonFor locationManager: CLLocationManager) -> Bool {
            if let location = mapView.myLocation?.coordinate {
                let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                                      longitude: location.longitude,
                                                      zoom: 14)
                mapView.animate(to: camera)
            }
            return true
        }
    }

    func setMapViewPin(){
        if pinIsSet{
            locationModel.requestLocation()
            DispatchQueue.main.async {
                let location = CLLocationCoordinate2D(latitude: locationModel.latitude ?? 0, longitude: locationModel.longitude ?? 0)
                locationCoordinate = location
                pinIsSet = false
                locationModel.requestLocationStop()
            }
        }
    }

    func fetchNearbyRestaurants(location: CLLocationCoordinate2D,type:String,completion: @escaping ([Place]) -> Void) {
        let currentLocation: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let searchRadius : Int = 2500
        let requestParam = NearbyLocationSearchRequest(currentLocation: currentLocation, locationType: type, searchRadius: searchRadius)
        googleClient.getGooglePlacesData(type: requestParam.locationType, location: requestParam.currentLocation, withinMeters: requestParam.searchRadius) { response in
            completion(response.results)
        }
    }

    func fetchPlaceDetails(completion: @escaping (Place) -> Void) {
        googleClient.fetchPlaceDetails(placeID: placeId) { place in
            if let p = place {
                completion(p)
            }
        }
    }
}
