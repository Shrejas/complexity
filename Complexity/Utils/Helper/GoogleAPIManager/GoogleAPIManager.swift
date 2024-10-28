//
//  GoogleAPIManager.swift
//  Complexity
//
//  Created by IE14 on 30/04/24.
//

import Foundation
import CoreLocation
import GooglePlaces

protocol GoogleClientRequest {
    
    var googlePlacesKey : String { get set }
    func getGooglePlacesData(type placeType: String, location: CLLocation,withinMeters radius: Int,using completionHandler: @escaping (GooglePlacesResponse) -> ())
    func getImageURl(_ photos:[Photo],completionHandler: @escaping ([URL]) -> ())
    func fetchPlacePhotos(placeId: String,using completionHandler: @escaping (GooglePhotoResponse) -> ())
    func fetchPlaceDetails(placeID: String, completion: @escaping (Place?) -> Void)
}

class GoogleClient: GoogleClientRequest {

    //URL Session
    let session = URLSession(configuration: .default)
    
    //Google Places Key
    var googlePlacesKey: String = StringConstants.GoogleAPIKey.key
    
    //async call to make a request to google for JSON
    func getGooglePlacesData(type placeType: String, location: CLLocation,withinMeters radius: Int,using completionHandler: @escaping (GooglePlacesResponse) -> ())  {
        
        let url = googlePlacesDataURL(forKey: googlePlacesKey, location: location, radius: radius, type: placeType)
        
        let task = session.dataTask(with: url) { (responseData, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = responseData ,let jsonString = String(data: data, encoding: .utf8) {
            }
    
            guard let data = responseData,
                let response = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) else {
                completionHandler(GooglePlacesResponse(results:[]))
                    return
                }
                completionHandler(response)
            }
            task.resume()
    }
    
    // create the URL to request a JSON from Google
    func googlePlacesDataURL(forKey apiKey: String, location: CLLocation, radius: Int,type : String) -> URL {
        
        let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        let locationString = "location=" + String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
        let radius = "radius=\(radius)"
        let type = "type=\(type)"
        let key = "key=" + apiKey
        let urlString = baseURL + locationString + "&" + type + "&" + radius + "&" + key
        return URL(string: urlString)!
    }
    
    // Function to create URL for fetching photo from Google
       func googlePhotoURL(forKey apiKey: String, photoReference: String) -> URL {
           let baseURL = "https://maps.googleapis.com/maps/api/place/photo?"
           let maxWidth = "maxwidth=400" // Set maximum width of the image
           let photoReference = "photoreference=\(photoReference)"
           let key = "key=" + apiKey
           let urlString = baseURL + maxWidth + "&" + photoReference + "&" + key
           return URL(string: urlString)!
       }
    
    func getImageURl(_ photos:[Photo] ,completionHandler: @escaping ([URL]) -> ()) {
        let photoURLs = photos.compactMap { photo -> URL? in
            let photoReference = photo.photoReference
            return self.googlePhotoURL(forKey: self.googlePlacesKey, photoReference: photoReference)
        }
        completionHandler(photoURLs)
    }
    
    func fetchPlacePhotos(placeId: String,using completionHandler: @escaping (GooglePhotoResponse) -> ()) {
        
           let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeId)&fields=photos&key=\(StringConstants.GoogleAPIKey.key)"
           guard let url = URL(string: urlString) else {
               return
           }
        
        let task = session.dataTask(with: url) { (responseData, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = responseData ,let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            
            guard let data = responseData,
                let response = try? JSONDecoder().decode(GooglePhotoResponse.self, from: data) else {
                completionHandler(GooglePhotoResponse(result: Result(photos: [])))
                    return
                }
                completionHandler(response)
            
        }
        task.resume()
    
    }
    
    func fetchPlaceDetails(placeID: String, completion: @escaping (Place?) -> Void) {
        let placesClient = GMSPlacesClient.shared()

        placesClient.lookUpPlaceID(placeID, callback: { (gmsPlace, error) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let gmsPlace = gmsPlace else {
                print("No place details for the given place ID.")
                completion(nil)
                return
            }

            let geometry = Geometry(location: Location(lat: gmsPlace.coordinate.latitude, lng: gmsPlace.coordinate.longitude))
            var place = Place()
            place.geometry = geometry
            place.name = gmsPlace.name
            place.placeID =  gmsPlace.placeID
            place.rating = Double(gmsPlace.rating)
            place.types = gmsPlace.types
            place.userRatingsTotal = Int(gmsPlace.userRatingsTotal)
            completion(place)
        })
    }
    
}
