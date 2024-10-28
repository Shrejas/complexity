//
//  PlaceMarker.swift
//  Complexity
//
//  Created by IE12 on 23/04/24.
//

import SwiftUI
import GoogleMaps

class PlaceMarker: GMSMarker {
  let place: Place
  
    init(place: Place, type: String) {
    self.place = place
    super.init()

    position = place.coordinate
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
 
        if type == "restaurant" || type == "bar"{
            icon = UIImage(named: type+"_pin")
        }
        else{
            icon = UIImage(named: "restaurant"+"_pin")
        }
  }
}

