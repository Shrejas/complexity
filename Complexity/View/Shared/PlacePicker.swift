//
//  PlacePicker.swift
//  Private MD Labs
//
//  Created by IE15 on 22/02/24.
//

import Foundation
import UIKit
import SwiftUI
import GooglePlaces
import GoogleMaps

enum FilterType {
    case establishment
    case places
}

struct PlacePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode

    @Binding var address: String
    @Binding var openPlacePicker:Bool
    @Binding var latitude: Double
    @Binding var longitude: Double
    @Binding var placeId: String 
    var filterType: FilterType = .establishment
    
    func makeCoordinator() -> GooglePlacesCoordinator {
        GooglePlacesCoordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PlacePicker>) -> GMSAutocompleteViewController {

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator


        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(GMSPlaceField.name.rawValue) | UInt64(GMSPlaceField.coordinate.rawValue) | UInt64(GMSPlaceField.placeID.rawValue))
                autocompleteController.placeFields = fields

        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter
        return autocompleteController
    }
    
    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: UIViewControllerRepresentableContext<PlacePicker>) {
        
    }
    
    class GooglePlacesCoordinator: NSObject, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {
        var parent: PlacePicker

        init(_ parent: PlacePicker) {
            self.parent = parent
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            DispatchQueue.main.async {
                self.parent.latitude = place.coordinate.latitude
                self.parent.longitude = place.coordinate.longitude
                self.parent.address = place.name ?? ""
                self.parent.openPlacePicker = false
                self.parent.placeId = place.placeID ?? ""
                self.parent.presentationMode.wrappedValue.dismiss()
            }
            
            
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            self.parent.$openPlacePicker.wrappedValue = false
            // parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
