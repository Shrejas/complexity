//
//  FindDetailView.swift
//  Complexity
//
//  Created by IE12 on 02/05/24.
//

import SwiftUI
import Kingfisher
import CoreLocation

struct FindDetailView: View {

    @Environment(\.presentationMode) var presentationMode
    @State private var rating = 4.5
    @Binding  var distance:Double
    @State var imageURls = [URL]()
    @Binding var locationCoordinate: CLLocationCoordinate2D?
    @Binding var urlImages:[URL]
    @Binding var isSheetPresented: Bool
    var placeId: String
    @StateObject private var store: LocationFeedStore
    var googleClient: GoogleClientRequest = GoogleClient()
    var selected:PlaceMarker
    @State private var feedPost: [FeedPost]?
    @State var isShowFeedDetailView: Bool = false
    @State var post: FeedPost = FeedPost(createdBy: 0,
               createdByUser: "John Doe",
               createdByUserProfilePicture: "profile.jpg",
               createdAt: "2024-06-18",
               createdTime: "15:30",
               likedByMe: false,
               likeCount: 10,
               commentCount: 5,
               postId: 123,
               drinkName: "Cappuccino",
               drinkBrand: "Starbucks",
               drinkCategory: "Coffee",
               drinkSubCategory: "Hot Drinks",
               caption: "Enjoying a nice cappuccino!",
               rating: 4,
               location: "Starbucks Coffee, New York",
               latitude: "40.7128",
               longitude: "-74.0060",
               placeId: "1234567890",
               media: ["image1.jpg", "image2.jpg"]
    )
    
    init(distance: Binding<Double>,
            locationCoordinate: Binding<CLLocationCoordinate2D?>,
            urlImages: Binding<[URL]>,
            isSheetPresented: Binding<Bool>,
            placeId: String,
            selected: PlaceMarker) {
           
           self._distance = distance
           self._locationCoordinate = locationCoordinate
           self._urlImages = urlImages
           self._isSheetPresented = isSheetPresented
           self.placeId = placeId
           self.selected = selected
           self._store = StateObject(wrappedValue: LocationFeedStore(placeId: placeId))
       }
    
 
    

    var body: some View {
        VStack{
            ZStack {
                if urlImages.count == 0 {
                    VStack{
                        Image("No-Image-Placeholder.svg")
                            .resizable()
                            .frame(height: 200)
                            .frame(width: 350)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                    }.padding(.horizontal,20)

                } else {
                    TabView {
                        ForEach(urlImages, id: \.self) { item in
                            KFImage(item)
                                .loadDiskFileSynchronously()
                                .resizable()
                                .placeholder{
                                    ProgressView()
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom,20)
                    .tabViewStyle(.page)
                    .background(.white)
                }
            }
            .padding(.horizontal,20)
            .frame(height: 250)
            .cornerRadius(10)
           
            
            
            
            if store.models.count == 0 {
                VStack(alignment: .center) {
                    Spacer()
                    Text("No post yet")
                        .fontWeight(.regular)
                        .foregroundColor(Color.gray)
                        .font(Font.system(size: 16))
                    Spacer()
                }
            } else {
                List {
                    Section {
                        ForEach(Array(store.models.enumerated()), id: \.element.id) { index, model in
                            ZStack {
                                PlaceDetailView(posts: store.models, post: model)
                                    .onTapGesture {
                                        self.post = model
                                        isShowFeedDetailView.toggle()
                                    }
                                    .onAppear {
                                        if store.enableLoadMore, !store.isLoadingMore, model.id == store.models.last?.id {
                                            store.loadMore()
                                        }
                                    }
                                
                                NavigationLink(destination: FeedDetailsView(post: self.$post), isActive: $isShowFeedDetailView) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                        }
                        
                        if store.isLoadingMore {
                            ProgressView()
                                .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                        }
                        
                    }
                    .listSectionSeparator(.hidden, edges: .bottom)
                    .listSectionSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .buttonStyle(.plain)
                .listRowSpacing(10)
                .refreshable {
                    store.refresh()
                }
            }
        }
        .onAppear {
            setDetails()
        }
        .navigationBarBackButtonHidden(true)

        .navigationBarTitle("Place details", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    isSheetPresented = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(Color._626465)
                    }
                }
            }
        }
    }
}

extension FindDetailView{

    func setDetails(){
        rating = selected.place.rating ?? 0
        UIPageControl.appearance().currentPageIndicatorTintColor = .gray
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
}



