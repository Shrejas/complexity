//
//  UserProfileView.swift
//  Complexity
//
//  Created by IE Mac 03 on 22/07/24.
//

import Foundation
import SwiftUI
import Kingfisher
import IQAPIClient
import Combine
import GoogleSignIn
import FirebaseMessaging

struct UserProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var profileViewModel: ProfileViewModel = ProfileViewModel()
    @State var showingAlertForDeletePost: Bool = false
    @State var isLoadMoreInProcess: Bool = false
    @State var isShowProfileView: Bool = false
    @State var isShowFeedDetailView: Bool = false
    @State var logoutButtonTapped: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var userFullName: String = ""
    @State private var userEmail: String =  ""
    @State private var userId: Int =  0
    @State private var selectedPostIndex: Int =  0
    @State private var selectedPostId: Int =  0
    
    var body: some View {
        VStack {
            NavigationLink(isActive: $isShowProfileView) {
                ProfileView()
            } label: {
                EmptyView()
            }
            
            NavigationLink(isActive: $isShowFeedDetailView) {
                if !profileViewModel.posts.isEmpty && profileViewModel.posts.count != 0 {
                    FeedDetailsView(post: $profileViewModel.posts[selectedPostIndex])
                }
            } label: {
                EmptyView()
            }
            
            ZStack(alignment: .top) {
                VStack {
                    Image("profileBackgroundImage")
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                }
                VStack(alignment: .center) {
                    HStack {
                        Text("")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.muliFont(size: 17, weight: .semibold))
                            .foregroundColor(Color._1D1A1A)
                            .frame(width: 100)
                            .padding(.trailing, 20)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 60)
                    
                    ZStack {
                        VStack(spacing: 10) {
                            Text(userFullName)
                                .font(.muliFont(size: 20, weight: .bold))
                                .foregroundColor(Color._2A2C2E)
                                .padding(.top, 40)
                            
                            Text(userEmail)
                                .font(.muliFont(size: 15, weight: .semibold))
                                .foregroundColor(Color._8A8E91)
                                .padding(.bottom, 30)
                        }
                        .background(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 127)
                        .cornerRadius(20)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        .padding(.horizontal, 16)
                        
                        VStack {
                            if let imageUrl = UserDefaultManger.getProfilePicture() {
                                KFImage(URL(string: imageUrl))
                                    .loadDiskFileSynchronously()
                                    .resizable()
                                    .placeholder{
                                        VStack {
                                            ProgressView()
                                        }
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(50)
                                        .background(Color.white)
                                    }
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(50)
                                    .padding(.top, 18)
                            }
                        }
                        .padding(.top, -150)
                    }
                    .padding(.horizontal, 0)
                    .padding(.top, 80)
                    HStack {
                        Text("Posts")
                            .font(.muliFont(size: 17, weight: .bold))
                            .foregroundColor(Color._2A2C2E)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                    
                    if profileViewModel.isLoading {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach((1...5), id: \.self) {_ in
                                    VStack {
                                        ProgressView()
                                    }
                                    .background(Color.white)
                                    .frame(height: 150)
                                }
                            }
                        }
                    } else {
                        if !profileViewModel.posts.isEmpty {
                            
                            ScrollView(showsIndicators: false) {
                                LazyVStack(spacing: 10) {
                                    ForEach(Array(profileViewModel.posts.enumerated()), id: \.element.postId) { index, post in
                                        PostFeedCellView(post: post) {
                                            selectedPostIndex = index
                                            isShowFeedDetailView = true
                                        }
                                        .onAppear {
                                            if index == profileViewModel.posts.count - 1 {
                                                print("last id \(post.postId)")
                                                if profileViewModel.isLoadingMore {
                                                    profileViewModel.loadMore(userId: userId)
                                                }
                                            }
                                        }
                                        if isLoadMoreInProcess {
                                            ProgressView()
                                        }
                                    }
                                    
                                    Spacer()
                                        .frame(height: 90)
                                }
                                .background(Color._F4F6F8)
                            }
                            .background(Color._F4F6F8.ignoresSafeArea())
                        }
                        else {
                            Text("You currently have no post.")
                                .font(.muliFont(size: 20, weight: .bold))
                                .foregroundColor(.black.opacity(0.5))
                        }
                    }
                }
            }
        }
        .background(Color._F4F6F8)
        .padding(.top, -50)
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button(action: {
            logoutButtonTapped = true
            
        }) {
            Image(ImageConstant.PtabIcon)
        })
        .navigationBarItems(leading:
                                Button(action: {
            isShowProfileView.toggle()
            
        }) {
            Image(systemName: "square.and.pencil")
                .foregroundColor(Color._1D1A1A)
        })
        .alert(isPresented: Binding<Bool>(
            get: {
                logoutButtonTapped || showingAlertForDeletePost
            },
            set: { newValue in
                if !newValue {
                    logoutButtonTapped = false
                    showingAlertForDeletePost = false
                }
            }
        )) {
            if logoutButtonTapped {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Yes"), action: {
                        logoutButtonAction()
                    }),
                    secondaryButton: .cancel(Text("Cancel"), action: {
                        logoutButtonTapped = false
                    })
                )
            } else if showingAlertForDeletePost {
                Alert(
                    title: Text("Confirm"),
                    message: Text("Are you sure you want to delete the post?"),
                    primaryButton: .destructive(Text("Yes"), action: {
                        profileViewModel.deletePost(postId: selectedPostId, userId: userId)
                    }),
                    secondaryButton: .cancel(Text("Cancel"), action: {
                        showingAlertForDeletePost = false
                    })
                )
            } else {
                Alert(title: Text(""))
            }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: .postDeleted)) { notification in
            if let postId = notification.userInfo?["postId"] as? Int {
                self.selectedPostId = postId
                showingAlertForDeletePost.toggle()
            }
        }

        .onAppear {
            getBasicInformation()
        }
        .toolbar(.hidden, for: .tabBar)
        
    }

    
    private func getBasicInformation() {
        if let name = UserDefaultManger.getName() {
            self.userFullName = name
        }
        if let email = UserDefaultManger.getEmail() {
            self.userEmail = email
        }
        if let userId = UserDefaultManger.getUserId() {
            if userId != 0 {
                self.userId = userId
                profileViewModel.getUserFeed(userId: userId)
            } else {
                logoutButtonAction()
            }
        }
    }
    
    private func logoutButtonAction() {
        GIDSignIn.sharedInstance.signOut()
        UserDefaultManger.clearAllData()
        NotificationCenter.default.post(name: .userLogoutNotification, object: nil)
        Messaging.messaging().deleteToken { error in
            if let error = error {
                print("Failed to delete FCM token:", error)
            } else {
                print("FCM token deleted successfully.")
                KeychainManager.token = nil
            }
        }
        appDelegate.setWindowGroup(AnyView(ContentView()))
    }
}
       
struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
