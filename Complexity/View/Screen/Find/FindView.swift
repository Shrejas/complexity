import SwiftUI
import CoreLocation
import AVFAudio
import HalfASheet

struct FindView: View {

    @StateObject var locationModel = LocationDataManager()
   // @StateObject private var store: LocationFeedStore
    @State private var isSet: Bool = true
    @State private var showSheet: Bool = false
    @State private var text: String = ""
    @State private var navigateToFindDetailView: Bool = false
    @State private var totalDistance: CLLocationDistance = 0.0
    @State var places = [Place]()
    @State var selectedPlace : Place?
    @State private var isDetailActive = false
    @State private var locationChange = false
    @State var openPlacePicker: Bool = false
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    @State var searchTextField: String = ""
    @State var locationCoordinate: CLLocationCoordinate2D?
    @State var locationCoordinate1: CLLocationCoordinate2D? = nil
    @State private var location = ""
    @State var selected = PlaceMarker(place: Place(), type: "")
    @State var showAlert = false
    @State var requestLocation = true
    @State var imageNameClose = false
    @State var placeId: String = ""
    @State var selectedPlaceId = ""
    @State private var distance = 0.0
    @State private var urlImages = [URL]()
    @State var isTapForLocationButton: Bool = false
    @State private var sheetOffset: CGFloat = 0.0
    
    var googleClient: GoogleClientRequest = GoogleClient()
    
    var body: some View {
        ZStack(alignment: .top) {
            
            NavigationLink(isActive: $navigateToFindDetailView) {
                FindDetailView(distance: $distance, locationCoordinate: $locationCoordinate, urlImages: $urlImages, isSheetPresented: $isDetailActive, placeId: selectedPlaceId, selected: selected)
            } label: {
                EmptyView()
            }

            MapView(isDetailActive: $isDetailActive, isTapForLocationButton: $isTapForLocationButton, placeId: $placeId, locationCoordinate: $locationCoordinate, locationCoordinate1: $locationCoordinate1, selected: $selected)
                .edgesIgnoringSafeArea(.all)
                .offset(y: sheetOffset) // Adjust the offset of the map

            VStack {
                HStack {
                    TextField("Search here", text: $location)
                        .disabled(true)
                        .font(.muliFont(size: 17, weight: .semibold))
                        .foregroundColor(Color._8A8E91)
                        .padding(.leading, 30)
                    Spacer()
                        .onTapGesture {
                            openPlacePicker.toggle()
                        }
                    Image(imageNameClose ? "close" : "search")
                        .resizable()
                        .frame(width: 20 ,height: 20)
                        .foregroundColor(Color._8A8E91)
                        .padding(.trailing, 30)
                        .onTapGesture {
                            if imageNameClose {
                                locationModel.requestLocation()
                                DispatchQueue.main.async {
                                    locationCoordinate1 = nil
                                    if let latitude = locationModel.latitude , let longitude = locationModel.longitude {
                                        locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                        locationModel.requestLocationStop()
                                        imageNameClose = false
                                        location = ""
                                    }
                                }
                            } else {
                                locationCoordinate = nil
                                isTapForLocationButton = false
                            }
                        }
                }
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 6)
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 10)
                Spacer()
            }
            .padding(.top,90)
            .onTapGesture {
                openPlacePicker.toggle()
            }
            HalfASheet(isPresented: $isDetailActive) {
                FindItemView(locationCoordinate: $locationCoordinate, isSheetPresented: $isDetailActive, navigateToFindDetailView: $navigateToFindDetailView, selected: $selected, distance: $distance, urlImages: $urlImages, placeId: $selectedPlaceId)
                    .navigationViewStyle(StackNavigationViewStyle())
                   .navigationBarTitleDisplayMode(.inline)
                   .navigationBarHidden(true)
                   .navigationBarBackButtonHidden(true)
            }
            .height(.fixed(500))
            .onChange(of: isDetailActive) { isActive in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                sheetOffset = isActive ? -200 : 0  
                            }
                        }
        }
        .ignoresSafeArea()
        .onAppear{
            getCurrentLocation()
        }
        .fullScreenCover(isPresented: $openPlacePicker) {
            PlacePicker(address: $location, openPlacePicker: $openPlacePicker, latitude: $latitude, longitude: $longitude, placeId: $placeId, filterType: .establishment)
                .onAppear{
                    isTapForLocationButton = false
                }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Location"),
                message: Text("Please allow your location in setting"),
                primaryButton: .default(Text("Allow"), action: {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }),
                secondaryButton: .default(Text("Don't Allow"), action: {
                })
            )
        }
        .onChange(of: latitude) { _ in
            locationCoordinate1 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            locationCoordinate = nil
            imageNameClose = true
        }
        .onChange(of: isTapForLocationButton){ valaue in
            if valaue {
                locationModel.requestLocation()
                DispatchQueue.main.async {
                    locationCoordinate1 = nil
                    if let latitude = locationModel.latitude , let longitude = locationModel.longitude {
                        locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        locationModel.requestLocationStop()
                        imageNameClose = false
                        location = ""
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Find")
        
    }

}


extension FindView{

    private func getCurrentLocation(){

        locationModel.requestManger()

        DispatchQueue.main.async {
            switch locationModel.authorizationStatus {

            case .authorizedWhenInUse:
                print("Current location data is allowed.")

            case .restricted, .denied:
                print("Current location data was restricted or denied.")
                showAlert.toggle()

            case .notDetermined:
                print("Finding your location...")
                locationModel.requestManger()
            default:
                print("Not determined")
            }
        }
    }
}

#Preview {
    FindView()
}
