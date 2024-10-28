//
//  SearchBarView.swift
//  Private MD Labs
//
//  Created by IE15 on 14/02/24.
//

import SwiftUI
import CoreLocation
struct LocationSearchBarView: View {
    //@StateObject private var locationViewModel = LocationViewModel()
    @State private var showAlert: Bool = false
    @State private var locationButtonTapped: Bool = false
    //@State private var cursorColor: Color = Color.neutral900
    @State private var searchTextField: String = ""
    @State private var openPlacePicker: Bool = false
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @Binding var searchText: String
    @Binding var searchBarPlaceHolder: String
    @Binding var selectedIndex: Int
    @FocusState private var keyboardFocused: Bool
   // @ObservedObject var viewModel: BookingVM
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            //Text(StringConstants.Bookings.labLocation)
                //.font( Font.sfProDisplay(size: 12, weight: .bold))
               // .kerning(0.6)
               // .foregroundColor(Color.neutral700)
               // .frame(maxWidth: .infinity, alignment: .topLeading)
            HStack(alignment: .center, spacing: 8) {
                Image("searchIcon")
                    .frame(width: 16, height: 16)
                TextField(searchBarPlaceHolder,text: $searchTextField)
//                    .font( Font.sfProDisplay(size: 14, weight: .regular))
//                    .foregroundColor(Color.neutral900)
                    .focused($keyboardFocused)
                   // .accentColor(cursorColor)
                    .focused($keyboardFocused)
                    .keyboardType(.numberPad)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
//                    .onChange(of: searchTextField) { newValue in
//                        searchText = searchTextField
//                        //     viewModel.labLocations.removeAll()
//                        if searchBarPlaceHolder == StringConstants.Bookings.searchBarPlaceHolderForStreetAddress {
//                            getSearchLocations(zip: "", lat: latitude , long: longitude)
//                            print(latitude,longitude)
//                        } else {
//                            getSearchLocations(zip: searchTextField, lat: 0 , long: 0)
//                        }
//                        if newValue.count == 0 {
//                            selectedIndex = -1
//                        }
//                        if searchBarPlaceHolder == StringConstants.Bookings.searchBarPlaceHolderForZipCode && newValue.count == 5 {
//                          //  KeyboardUtility.hideKeyboard()
//                        }
//                    }
                    .onTapGesture {
                        searchTextField = ""
                    }
                    .overlay(
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                          //  .opacity(searchBarPlaceHolder == StringConstants.Bookings.searchBarPlaceHolderForStreetAddress ? 1 : 0)
                            .onTapGesture {
                                openPlacePicker = true
                            }
                    )
//                if searchTextField.isEmpty {
//                    Image("Location")
//                        .frame(width: 16, height: 16)
//                        .onTapGesture {
//                            locationButtonTapped = true
//                            if let latitude = self.locationViewModel.latitude, let longitude = self.locationViewModel.longitude {
//                                print("Latitude: \(latitude), Longitude: \(longitude)")
//                                self.latitude = latitude
//                                self.longitude = longitude
//                               // locationViewModel.getAddressFromLatLon(latitude: latitude, longitude: longitude) { address in
//                                    if let address = address {
//                                        searchTextField = address
//                                    } else {
//                                        print("Failed to retrieve address")
//                                    }
//                                }
//                                self.latitude = latitude
//                                self.longitude = longitude
//                                getSearchLocations(zip: "", lat: latitude, long: longitude)
//                            } else {
//                                showAlert.toggle()
//                                print("Allow for location")
//                            }
//                        }
//                        .onAppear {
//                            self.locationViewModel.requestLocation()
//                        }
//                } else if locationButtonTapped {
//                    if searchTextField.isEmpty {
//                        ProgressView()
//                    } else {
//                        Image("Cross")
//                            .frame(width: 16, height: 16)
////                            .onTapGesture {
////                                KeyboardUtility.hideKeyboard()
////                                latitude = 0.0
////                                longitude = 0.0
////                                //                viewModel.labLocations.removeAll()
////                                getSearchLocations(zip: "", lat: latitude , long: longitude)
////                                searchTextField = ""
////                            }
//                    }
//                } else if !searchTextField.isEmpty {
                    Image("Cross")
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                          //  KeyboardUtility.hideKeyboard()
                            latitude = 0.0
                            longitude = 0.0
                           // getSearchLocations(zip: "", lat: latitude , long: longitude)
                            searchTextField = ""
                           // viewModel.showEmptyDataView = false
                        }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.5)
                    //.stroke(searchTextField.isEmpty ? Color.neutral300: Color.primary500)
            )
//            .modifier(LocationSettingsAlertModifier(showAlert: $showAlert, authorizationStatus: CLLocationManager.authorizationStatus()))
            //          .alert(isPresented: $showAlert) {
            //            Alert (title: Text("Location access required to take Your Location"),
            //                message: Text("Go to Settings?"),
            //                primaryButton: .default(Text("Settings"), action: {
            //              UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            //            }),
            //                secondaryButton: .default(Text("Cancel")))
            //          }
       // }


//        .fullScreenCover(isPresented: $openPlacePicker) {
//                   PlacePicker(address: $searchTextField, openPlacePicker: $openPlacePicker, latitude: $latitude, longitude: $longitude)
//               }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.white)
        .cornerRadius(16)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(action: {
                    keyboardFocused = false
                }, label: {
                    Text("Done")
                })
            }
        }
    }
//    private func getSearchLocations(zip: String, lat: Double, long: Double) {
//        //    print(zip,lat,long)
//        viewModel.labLocations.removeAll()
//        if lat != 0 && long != 0 {
//            viewModel.getLocations(zip: "", lat: "\(lat)", lng: "\(long)")
//        } else if isValidZIPCode(zip) {
//            viewModel.getLocations(zip: zip, lat: "", lng: "")
//        }
//    }
//    private func isValidZIPCode(_ zipCode: String) -> Bool {
//        let zipCodeRegex = #"^\d{5}(?:[-\s]?\d{4})?$"#
//        let zipCodePredicate = NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
//        return zipCodePredicate.evaluate(with: zipCode)
//    }
}

