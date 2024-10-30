//
//  ProfileView.swift
//  Complexity
//
//  Created by IE on 16/07/24.
//

import Foundation
import SwiftUI
import Kingfisher
import IQAPIClient
import Combine

struct PostProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var errorMessage: String = ""
    @State var alertTitle: String = ""
    @State var brandName: String = ""
    @State var name: String = ""
    @State var description: String = ""
    @State var likes: Int = 147
    @State var rating: Double = 4.0
    @State var selectedPostIndex: Int = 0
    @State var isShowDrinkDetail: Bool = false
    @State public var isShowAlert: Bool = false
    @StateObject private var postProfileViewModel: PostProfileViewModel = PostProfileViewModel()
    
    let userInfo: UserInfo
    @Binding var isShowProfileView: Bool
    
    var body: some View {
        VStack {
            NavigationLink(isActive: $isShowDrinkDetail) {
                if !postProfileViewModel.posts.isEmpty {
                    FeedDetailsView(post: $postProfileViewModel.posts[selectedPostIndex])
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
                        Button {
                            isShowProfileView = false
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            HStack {
                                Image(systemName: "arrow.backward")
                                    .foregroundColor(Color._626465)
                                    .frame(width: 34, height: 34)
                                    .background(Color.white)
                            }.cornerRadius(17)

                        }
                        .padding(.leading, 0)
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Profile")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.muliFont(size: 17, weight: .semibold))
                                .foregroundColor(Color._1D1A1A)
                                .frame(width: 100)
                                .padding(.leading, 15)
                        }
                      
                        Spacer()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 60)
                    
                    ZStack {
                        VStack(spacing: 10) {
                            Text(userInfo.name)
                                .font(.muliFont(size: 20, weight: .bold))
                                .foregroundColor(Color._2A2C2E)
                                .padding(.top, 40)
                            
                            Text(userInfo.email)
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
                            KFImage(URL(string: userInfo.profilePicture))
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
                    
                    if !postProfileViewModel.posts.isEmpty {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 10) { // Spacing between cells
                                ForEach(Array(postProfileViewModel.posts.enumerated()), id: \.element.postId) { index, post in
                                    
                                    PostFeedCellView(post: post) {
                                        selectedPostIndex = index
                                        isShowDrinkDetail = true
                                    }
                                        .onAppear {
                                            if index == postProfileViewModel.posts.count - 1 {
                                                print("last id \(post.postId)")
                                                if postProfileViewModel.isLoadingMore {
                                                    postProfileViewModel.loadMore(userId: userInfo.userId)
                                                }
                                            }
                                        }
                                        .onTapGesture {
                                            selectedPostIndex = index
                                            isShowDrinkDetail = true
                                        }
                                    
                                    // Loading indicator if loading more items
                                    if postProfileViewModel.isLoadMoreProcess {
                                        ProgressView()
                                    }
                                }
                            }
                            .padding(.bottom, 70) // Bottom padding for spacing after the last cell
                            .background(Color._F4F6F8) // Apply background color directly to the VStack
                        }
                        .background(Color._F4F6F8.ignoresSafeArea())
                    }
                    if postProfileViewModel.isLoading {
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
                }
            }
        }
        .background(Color._F4F6F8)
        .padding(.horizontal, 20)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .onAppear {
            postProfileViewModel.getUserFeed(userId: userInfo.userId)
        }
        .alert(isPresented: $postProfileViewModel.showAlert, content: {
            Alert(title: Text("Error!"), message: Text(postProfileViewModel.errorMessage), dismissButton: .destructive(Text("Ok")))
        })
    }
    
}
       
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PostProfileView(userInfo: UserInfo(userId: 0, userIdentifier: "", name: "InfoEnum", email: "example@gmail.com", userName: "Infoenum", profilePicture: "", location: "", latitude: "", longitude: "", placeId: ""), isShowProfileView: .constant(false))
    }
}


