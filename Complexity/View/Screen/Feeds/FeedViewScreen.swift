//
//  FeedViewScreen.swift
//  Complexity
//
//  Created by IE12 on 23/04/24.
//

import Foundation
import SwiftUI

struct FeedViewScreen: View {
    
    @StateObject private var store: FeedStore = FeedStore()
    @State private var isPresentingModal = false
    @State private var isPlusButtonTapped: Bool = false
    @State private var isNotificationViewActive = false
    @State private var pageIndex: Int = 1
    @State private var comment = 03
    @State private var isLocationTapped: Bool = false
    @State private var isImageTapped: Bool = false
    @State private var isDrinkNameViewShow: Bool = false
    @State private var selectedIndex: Int = 0
    @State private var selectedPostId: Int = 0
    @State private var navigateToDetail: Bool = false
    @State private var selectedPostID: Int = 0
    @State private var selectedDetailPost: FeedPost?
    @State private var selectedImagePost: FeedPost = FeedPost(createdBy: 0, createdByUser: "", createdByUserProfilePicture: "", createdAt: "", createdTime: "", likedByMe: false, likeCount: 0, commentCount: 0, postId: 0, drinkName: "", drinkBrand: "", drinkCategory: "", drinkSubCategory: "", caption: "", rating: 0, location: "", latitude: "", longitude: "", placeId: "", media: [])
    @State private var isSearching = false
    @State private var searchText = ""
    @StateObject var viewModel = FeedSearchViewModel()
    @StateObject private var feedViewModel = FeedViewModel()
    @State private var searchBarFrame: CGRect = .zero
    @State private var showResults = true
    @State private var selectedDrinkId: Int = 0
    @State private var showDetailProfileView: Bool = false
    @State private var showFeedDetailView: Bool = false
    @State private var showNoResult: Bool = false
    @State private var selectedFeedDetailModel: FeedPost?
    @State private var isPostDeleted: Bool = false
    @State private var showLikesSheet: Bool = false
    @State private var isShowProfileView: Bool = false
    @State private var selectedPostIdForShowLikes: Int = 0
    @State private var userInfo: UserInfo?
    @EnvironmentObject var router: Router
    
    init() { }
    
    fileprivate init(store: FeedStore) {
        _store = StateObject(wrappedValue: store)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
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
                
                NavigationLink(isActive: $isLocationTapped) {
                    if let selectedDetailPost = selectedDetailPost {
                        LocationDetailsView(post: selectedDetailPost)
                    }
                } label: {
                    EmptyView()
                }
                
                VStack {
                    VStack {
                        SearchBarView(searchText: $viewModel.searchText, isSearching: $isSearching, isLoading: $viewModel.isLoading)
                            .onChange(of: viewModel.searchText) { newValue in
                                if !newValue.trimmingCharacters(in: .whitespaces).isEmpty  {
                                    viewModel.getSearchDrinkData(drinkName: viewModel.searchText)
                                } else {
                                    store.refresh()
                                }
                            }
                            .padding(.top, 10)
                            .padding(.bottom,10)
                            .padding(.horizontal,20)
                        
                    }
                    ZStack {
                        if store.isRefreshing && store.models.count == 0 {
                            VStack {
                                ScrollView(showsIndicators: false) {
                                    ForEach( 0..<5){_ in
                                        FeedScreenSkeltonView(isSkeletonUIPresenting: store.isRefreshing)
                                    }
                                }
                            }
                        } else {
                            List {
                                if store.models.count == 0 {
                                    ZStack{
                                        Image("EmptyImage")
                                            .resizable()
                                            .scaledToFill()
                                        Text("You currently have no Posts.")
                                            .font(.muliFont(size: 25, weight: .bold))
                                            .foregroundColor(.black.opacity(0.5))
                                    }
                                } else {
                                    Section {
                                        ForEach(Array($store.models.enumerated()), id: \.element.id) { index, model in
                                            ZStack {
                                                
                                                FeedViewCell(isLocationNameClickable: true,
                                                             isDrinkNameClickable: true,
                                                             posts: $store.models,
                                                             post: model,
                                                             isPostDeleted: $isPostDeleted,
                                                             selectedPostIdForShowLikes: $selectedPostIdForShowLikes,
                                                             showLikesSheet: $showLikesSheet)
                                                { post in
                                                    selectedDetailPost = post
                                                    isLocationTapped.toggle()
                                                } onDrinkNameTap: { post in
                                                    selectedDetailPost = post
                                                    searchText = ""
                                                    router.navigate(to: .drinkNameView(post: post))
                                                    isDrinkNameViewShow.toggle()
                                                } onDrinkImageTap: { post in
                                                    selectedDetailPost = post
                                                    selectedImagePost = post
                                                    showFeedDetailView = true
                                                }
                                                
                                                .onAppear {
                                                    UIApplication.shared.endEditingg()
                                                    if viewModel.enableLoadMore, !viewModel.isLoadingMore, model.id == store.models.last?.id {
                                                        viewModel.loadMore { result in
                                                            switch result {
                                                            case .success(let data):
                                                                if let post = data.post {
                                                                    store.models += post
                                                                }
                                                            case .failure(_):
                                                                break
                                                            }
                                                        }
                                                    }
                                                    if store.enableLoadMore, !store.isLoadingMore, model.id == store.models.last?.id {
                                                        store.loadMore()
                                                    }
                                                }
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
                                    Section {
                                        VStack {
                                            Rectangle()
                                                .fill(.clear)
                                                .frame(height: 130)
                                        }
                                    }
                                    .listSectionSeparator(.hidden, edges: .bottom)
                                    .listSectionSeparator(.hidden)
                                }
                            }
                            .listStyle(.plain)
                            .buttonStyle(.plain)
                            
                            .refreshable {
                                store.refresh()
                                viewModel.searchText = ""
                            }
                        }
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    router.navigate(to: .newPostView)
                                    isPlusButtonTapped = true
                                }, label: {
                                    Image(ImageConstant.plusIcon)
                                        .frame(width: 56,height: 56)
                                })
                                .padding(.trailing,25)
                            }
                            .padding(.bottom,90)
                        }
                    }
                    .onChange(of: viewModel.feedSearchData) { newValue in
                        if newValue?.post?.isEmpty ?? false && viewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                            store.refresh()
                        } else {
                            store.models = viewModel.feedSearchData?.post ?? []
                        }
                    }
                }
                
                .onChange(of: selectedDrinkId, perform: { value in
                    if value != 0 {
                        router.navigate(to: .drinkDetailProfileView(drinkID: value))
                    }
                })
                
                .onChange(of: isPostDeleted, perform: { value in
                    if value {
                        store.refresh()
                        isPostDeleted = false
                    }
                })
                
                .onReceive(NotificationCenter.default.publisher(for: .callRefreshMethod)) { _ in
                    store.refresh()
                }
                .onAppear {
                    store.refresh()
                    feedViewModel.getFeedData(pageIndex: 1, pageSize: 10)
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle(Text("Feed"), displayMode: .inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                    router.navigate(to: .notificationView)
                }){
                    ZStack {
                        Image(ImageConstant.notificationIcon)
                        if let badgeCount = feedViewModel.feedData?.badgeCount, badgeCount != 0  {
                            Text("\(badgeCount)")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 10, y: -10)
                        }
                    }
                    
                }
                ).navigationBarColor(.white)
                
                if showResults && !viewModel.searchText.isEmpty {
                    SearchResultList(drinkInfo: viewModel.searchDrinksData, selectedDrinkId: $selectedDrinkId, showNoResult: $viewModel.showNoResultDrinkSearch)
                        .cornerRadius(10)
                        .animation(.easeInOut, value: showResults)
                        .offset(y: showResults ? 55 : -UIScreen.main.bounds.height)
                        .transition(.move(edge: .top))
                        .padding(.bottom, 0)
                        .frame(maxHeight: .infinity)
                }
            }
            .sheet(isPresented: $showLikesSheet) {
                PostLikesSheetView(userInfo: $userInfo, isShowProfileView: $isShowProfileView, postId: $selectedPostIdForShowLikes)
                    .presentationDetents([.fraction(0.8), .large])
            }
            .onAppear{
                searchText = ""
                viewModel.searchText = ""
                selectedDrinkId = 0
            }
            
            
            .onReceive(NotificationCenter.default.publisher(for: .navigateToUserProfile)) { notification in
                if let userId = notification.userInfo?["userId"] as? Int {
                    feedViewModel.getProfileDetail(userId: userId){ result in
                        switch result {
                        case .success(_):
                            self.userInfo = feedViewModel.userInfo
                            self.isShowProfileView.toggle()
                            break
                        case .failure(_):
                            break
                        }
                    }
                }
            }
            .hideKeyboardOnTap()
        }
    }
}

struct FeedViewScreen_Previews: PreviewProvider {
    static var previews: some View {
        FeedViewScreen()
    }
}

extension UIApplication {
    func endEditingg() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
struct KeyboardUtility {
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            KeyboardUtility.hideKeyboard()
        }
    }
}
