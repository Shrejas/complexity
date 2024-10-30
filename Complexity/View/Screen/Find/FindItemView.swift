


//
//  ItemDetailView.swift
//  Complexity
//
//  Created by IE14 on 01/05/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct FindItemView: View {

    @StateObject var locationModel = LocationDataManager()
    @Binding var locationCoordinate: CLLocationCoordinate2D?
    @Binding var isSheetPresented: Bool
    @Binding var navigateToFindDetailView: Bool
    @Binding var selected:PlaceMarker
    @State private var isTapped:Bool = false
    @State private var rating = 4.5
    @Binding  var distance : Double
    var googleClient: GoogleClientRequest = GoogleClient()
    @Binding  var urlImages : [URL]
    @Binding var placeId: String


    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading,spacing: 3) {
                
                //            Text("Nearby Restaurants, Bars, and Stores")
                //                .font(.muliFont(size: 17,weight: .bold))
                //                .padding(.top, 20)
                //                .frame(alignment: .leading)
                if let name = selected.place.name{
                    Text( name )
                        .font(.muliFont(size: 17,weight: .bold))
                        .foregroundColor(._2A2C2E)
                }
                if let vicinity = selected.place.vicinity {
                    Text( vicinity )
                        .font(.muliFont(size: 15,weight: .regular))
                        .foregroundColor(Color._8A8E91)
                }
                
                HStack(){
                    Text("\(rating, specifier: "%.1f")")
                        .font(.muliFont(size: 15,weight: .regular))
                        .foregroundColor(Color._2A2C2E)
                    
                    FractionalRatingView(rating: $rating)
                    
                    Text("(\(selected.place.userRatingsTotal ?? 0))")
                        .font(.muliFont(size: 15,weight: .regular))
                        .foregroundColor(Color._2A2C2E)
                    Spacer()
                }.padding(.top,-5)
                
                Text("Distance: \((distance * 0.621371), specifier: "%.2f") miles")
                    .font(.muliFont(size: 15,weight: .regular))
                    .foregroundColor(Color._8A8E91)
                    .padding(.top,-5)
                
                HStack {
                    ScrollView(.horizontal,showsIndicators: false) { //
                        HStack {
                            ForEach(urlImages.chunked(into: 3), id: \.self) { item in
                                FindNearByItemCell(imgaeURL: item)
                            }
                        }
                    }
                }
                .padding(.top, 10)
                
                Button(action: {
                    isTapped.toggle()
                    isSheetPresented = false
                    navigateToFindDetailView = true
                }) {
                    Text("View Details")
                        .font(.muliFont(size: 15,weight: .regular))
                        .foregroundColor(._4F87CB)
                    Image("arrow1")
                        .frame(alignment: .center)
                        .padding(.top,4)
                }
                .frame(width: 108,height: 30 , alignment: .leading)
                .cornerRadius(10)
                Rectangle()
                    .frame(height: 80)
                    .background(Color.clear)
                    .foregroundColor(Color.clear)
            }
            .padding(.top, 10)
            .onAppear{
                locationModel.requestLocation()
                DispatchQueue.main.async {
                    getDistance()
                }
                setDetails()
                fetchGoogleImage()
                placeId = selected.place.placeID ?? ""
            }
            .padding(.horizontal, 10)
        }
    }
}

extension FindItemView{
    
    func getDistance() {
        guard let lat = selected.place.geometry?.location.lat,
              let lng = selected.place.geometry?.location.lng else {
            return
        }
        let coordinate2 = CLLocation(latitude: lat, longitude: lng)
        distance = locationModel.distanceBetweenLocations1(location: coordinate2) ?? 0.0
        distance /= 1000.0
    }

    func setDetails() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            rating = selected.place.rating ?? 0.0
        }
    }

    func fetchGoogleImage(){
        googleClient.fetchPlacePhotos(placeId: selected.place.placeID ?? "") { result in
            let photos = result.result.photos
            googleClient.getImageURl(photos ,completionHandler: { url in
                urlImages = url
            })
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks = [[Element]]()
        for i in stride(from: 0, to: self.count, by: size) {
            let chunk = Array(self[i..<Swift.min(i + size, self.count)])
            chunks.append(chunk)
        }
        return chunks
    }
}
