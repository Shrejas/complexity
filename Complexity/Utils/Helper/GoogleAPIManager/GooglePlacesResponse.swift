//
//  ResponseModels.swift
//  CoffeeTime
//
//  Created by Bryan Ryczek on 1/29/18.
//  Copyright © 2018 Bryan Ryczek. All rights reserved.
//
import Foundation
import CoreLocation

struct GooglePlacesResponse : Codable {
    var results : [Place]
    enum CodingKeys: String,CodingKey {
        case results = "results"
    }
}

struct Place: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(placeID)
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.businessStatus == rhs.businessStatus &&
        lhs.geometry == rhs.geometry  &&
        lhs.icon == rhs.icon &&
        lhs.iconBackgroundColor == rhs.iconBackgroundColor  &&
        lhs.name == rhs.name &&
        lhs.photos == rhs.photos  &&
        lhs.placeID == rhs.placeID &&
        lhs.plusCode == rhs.plusCode  &&
        lhs.rating == rhs.rating &&
        lhs.reference == rhs.reference  &&
        lhs.types == rhs.types &&
        lhs.vicinity == rhs.vicinity
    }
    
    let businessStatus: String?
    var geometry: Geometry?
    let icon: String?
    let iconBackgroundColor: String?
    let iconMaskBaseURI: String?
    var name: String?
    let photos: [Photo]?
    var placeID: String?
    let plusCode: PlusCode?
    var rating: Double?
    let reference: String?
    let scope: String?
    var types: [String]?
    var userRatingsTotal: Int?
    let vicinity: String?
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geometry?.location.lat ?? 0, longitude: geometry?.location.lng ?? 0)
    }

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry, icon
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseURI = "icon_mask_base_uri"
        case name, photos
        case placeID = "place_id"
        case plusCode = "plus_code"
        case rating, reference, scope, types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
    }
    
    init(businessStatus: String = "", geometry: Geometry = Geometry(location: Location(lat: 0, lng: 0), viewport: Viewport(northeast: Location(lat: 0, lng: 0), southwest: Location(lat: 0, lng: 0))), icon: String = "", iconBackgroundColor: String = "", iconMaskBaseURI: String = "", name: String = "", photos: [Photo] = [], placeID: String = "", plusCode: PlusCode = PlusCode(compoundCode: "", globalCode: ""), rating: Double = 0.0, reference: String = "", scope: String = "", types: [String] = [], userRatingsTotal: Int = 0, vicinity: String = "") {
          self.businessStatus = businessStatus
          self.geometry = geometry
          self.icon = icon
          self.iconBackgroundColor = iconBackgroundColor
          self.iconMaskBaseURI = iconMaskBaseURI
          self.name = name
          self.photos = photos
          self.placeID = placeID
          self.plusCode = plusCode
          self.rating = rating
          self.reference = reference
          self.scope = scope
          self.types = types
          self.userRatingsTotal = userRatingsTotal
          self.vicinity = vicinity
        }
}

struct Geometry: Codable, Equatable {
    
    var location: Location
    var viewport: Viewport?
    
    static func == (lhs: Geometry, rhs: Geometry) -> Bool {
         lhs.location == rhs.location &&
         lhs.viewport == rhs.viewport
    }
}

struct Location: Codable, Equatable {
    
    let lat, lng: Double
    static func == (lhs: Location, rhs: Location) -> Bool {
         lhs.lat == rhs.lat &&
         lhs.lng == rhs.lng
    }
}

struct Viewport: Codable , Equatable{
    let northeast, southwest: Location
    
    static func == (lhs: Viewport, rhs: Viewport) -> Bool {
         lhs.northeast == rhs.northeast &&
         lhs.southwest == rhs.southwest
    }
}

struct Photo: Codable, Equatable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
         lhs.height == rhs.height &&
         lhs.htmlAttributions == rhs.htmlAttributions &&
        lhs.photoReference == rhs.photoReference &&
        lhs.width == rhs.width
    }
}

struct PlusCode: Codable, Equatable {
    let compoundCode, globalCode: String

    private enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
    
    static func == (lhs: PlusCode, rhs: PlusCode) -> Bool {
         lhs.compoundCode == rhs.compoundCode &&
         lhs.globalCode == rhs.globalCode
    }
}

struct NearbyLocationSearchRequest {
    var currentLocation: CLLocation
    var locationType: String
    var searchRadius: Int
}
