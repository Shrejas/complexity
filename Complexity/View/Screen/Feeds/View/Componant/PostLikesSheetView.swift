//
//  PostLikesSheetView.swift
//  Complexity
//
//  Created by IE Mac 03 on 16/07/24.
//

import Foundation
import SwiftUI
import IQAPIClient
import Kingfisher

struct PostLikesSheetView: View {
    
    @State var postLikes: [Likes] = []
    @State var errorMessage: String = ""
    @State var showingAlert: Bool = false
    @State var showProgressView: Bool = false
    @Binding var userInfo: UserInfo?
    @Binding var isShowProfileView: Bool
    @Environment(\.dismiss) var dismiss
    @Binding var postId: Int
    
    
    var body: some View {
        NavigationView {
            VStack {
                if !showProgressView {
                    HStack {
                        Text("Likes")
                            .font(.muliFont(size: 22, weight: .semibold))
                            .foregroundColor(Color._1D1A1A)
                        Spacer()
                        Text("Total Likes: \(postLikes.count)")
                            .font(.muliFont(size: 15, weight: .semibold))
                            .foregroundColor(Color._4CC6B2)
                    }
                    ForEach(postLikes, id: \.userId) { like in
                        
                        HStack {
                            KFImage(URL(string: APIPath.baseUrl.rawValue + like.profilePicture))
                                .loadDiskFileSynchronously()
                                .resizable()
                                .placeholder{
                                    ProgressView()
                                }
                                .frame(width: 68, height: 68)
                                .cornerRadius(34)
                            
                            Text(like.name)
                                .font(.muliFont(size: 17, weight: .semibold))
                                .foregroundColor(Color._1D1A1A)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .onTapGesture {
                            getProfileDetail(userId: like.userId)
                        }
                        
                    }
                    Spacer()
                } else {
                    ProgressView()
                }
                
            }
            .background(Color.clear)
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onAppear {
                getPostLikes(postId: postId)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error!"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func getPostLikes(postId: Int) {
        self.showProgressView = true
        IQAPIClient.getPostLikes(postId: postId) { httpUrlResponse, result  in
            self.showProgressView = false
            switch result {
            case .success(let data):
                let likes = data.likes
                self.postLikes = likes
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showingAlert.toggle()
            }
        }
    }
    
    private func getProfileDetail(userId: Int) {
        self.showProgressView = true
        IQAPIClient.getProfile(userId: userId) { httpUrlResponse, result  in
            self.showProgressView = false
            switch result {
            case .success(let data):
                self.userInfo = data.userInfo
                isShowProfileView = true
                dismiss()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showingAlert.toggle()
            }
        }
    }
}

