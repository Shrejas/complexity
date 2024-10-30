//
//  LocationDetailsView.swift
//  Complexity
//
//  Created by IE12 on 03/05/24.
//

import SwiftUI

struct LocationDetailsView: View {

    @Environment(\.presentationMode) var presentationMode

    let post: FeedPost

    @StateObject private var store: LocationFeedStore

    @State private var isPresentingModal = false
    @State private var isDrinkNameViewShow: Bool = false
    @State private var selectedDetailPost: FeedPost?
    @State private var isPostDeleted: Bool = false
    @State private var showFeedDetailView: Bool = false
    @State private var selectedImagePost: FeedPost = FeedPost(createdBy: 0, createdByUser: "", createdByUserProfilePicture: "", createdAt: "", createdTime: "", likedByMe: false, likeCount: 0, commentCount: 0, postId: 0, drinkName: "", drinkBrand: "", drinkCategory: "", drinkSubCategory: "", caption: "", rating: 0, location: "", latitude: "", longitude: "", placeId: "", media: [])
    @State private var showLikesSheet: Bool = false
    @State private var isShowProfileView: Bool = false
    @State private var selectedPostIdForShowLikes: Int = 0
    @State private var userInfo: UserInfo?
    
    init(post: FeedPost) {
        self.post = post
        _store = StateObject(wrappedValue: LocationFeedStore(placeId: post.placeId))
    }

    var body: some View {
        VStack{
            ZStack {
                NavigationLink(isActive: $isShowProfileView) {
                    if let userInfo = self.userInfo {
                        PostProfileView(userInfo: userInfo, isShowProfileView: $isShowProfileView)
                    }
                    
                } label: {
                    EmptyView()
                }
                .opacity(0)
                
                NavigationLink(isActive: $showFeedDetailView) {
                    FeedDetailsView(post: $selectedImagePost)
                } label: {
                    EmptyView()
                }

                if store.isRefreshing && store.models.count == 0 {
                    ProgressView()
                    Spacer()
                } else {
                    List {
                        if store.models.count == 0 {
                            Section {
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text("No post yet")
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.gray)
                                        .font(Font.system(size: 16))
                                        .padding(.top, 200)
                                    Spacer()
                                }
                                .listSectionSeparator(.hidden, edges: .bottom)
                                .listSectionSeparator(.hidden)
                            }
                        } else {
                            Section {
                                ForEach($store.models) { model in
                                    ZStack {
                                        FeedViewCell(isLocationNameClickable: false,
                                                     isDrinkNameClickable: true,
                                                     posts: $store.models,
                                                     post: model,
                                                     isPostDeleted: $isPostDeleted,
                                                     selectedPostIdForShowLikes: $selectedPostIdForShowLikes, 
                                                     showLikesSheet: $showLikesSheet)
                                        { post in

                                        } onDrinkNameTap: { post in
                                            selectedDetailPost = post
                                            //isDrinkNameViewShow.toggle()
                                            
                                        } onDrinkImageTap: { post in
                                            selectedDetailPost = post
                                            selectedImagePost = post
                                            showFeedDetailView = true
                                        }
                                        .onAppear {
                                            if store.enableLoadMore, !store.isLoadingMore, model.id == store.models.last?.id {
                                                store.loadMore()
                                            }
                                        }
                                        NavigationLink(destination: FeedDetailsView(post: model)) {
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
                    }
                    .listStyle(.plain)
                    .buttonStyle(.plain)
                    .listRowSpacing(10)
                    .refreshable {
                        store.refresh()
                    }
                }
            }
        }
        .onChange(of: isPostDeleted, perform: { newValue in
            if newValue {
                store.refresh()
                isPostDeleted = false
            }
        })
        .sheet(isPresented: $showLikesSheet) {
            PostLikesSheetView(userInfo: $userInfo, isShowProfileView: $isShowProfileView, postId: $selectedPostIdForShowLikes)
                .presentationDetents([.fraction(0.8), .large])
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text(post.location ?? "Location")
                            , displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
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

//#Preview {
//    LocationDetailsView()
//}
