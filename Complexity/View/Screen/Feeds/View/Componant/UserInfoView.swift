//
//  UserInfoView.swift
//  Complexity
//
//  Created by IE Mac 05 on 14/05/24.
//

import SwiftUI
import Kingfisher
import IQAPIClient

struct UserInfoView: View {
    @StateObject var viewModel: FeedViewCellViewModel = FeedViewCellViewModel()
    @State private var showDeleteAlert: Bool = false
    @State private var showReportAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var alertTitle: String = "Alert"
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var feedModel: FeedModel?
    @Binding var isPostDeleted: Bool
    @State private var isLoading = true
    @State private var hasError = false
    let postDetail: FeedPost
    let isLocationNameClickable: Bool
    let onLocationTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
               
                if let url = postDetail.createdByUserProfilePicture {
                    KFImage(URL(string: url))
                        .resizable()
                        .placeholder{
                            ProgressView()
                                .frame(width: 38, height: 38)
                        }
                        .resizable()
                        .frame(width: 38,height: 38)
                        .cornerRadius(19)
                        .scaledToFit()
                        .onTapGesture {
                            NotificationCenter.default.post(name: .navigateToUserProfile, object: nil, userInfo: ["userId": postDetail.createdBy ?? 0])
                        }
                        
                }
                
                HStack(alignment: .center, spacing: 5) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(postDetail.createdByUser ?? "")
                            .font(.muliFont(size: 15, weight: .bold))
                            .foregroundColor(Color._2A2C2E)
                            .frame(alignment: .topLeading)
                        HStack {
                            Image(ImageConstant.location)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            Button(action: {
                                if isLocationNameClickable {
                                    onLocationTap()
                                }
                            }) {
                                Text(postDetail.location ?? "")
                                    .font(.muliFont(size: 12, weight: .regular))
                                    .foregroundColor(Color._8A8E91)
                            }
                        }
                        HStack {
                            Image(systemName: "calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color._8A8E91)
                            Text(postDetail.createdTime ?? "")
                                .font(.muliFont(size: 12, weight: .regular))
                                .foregroundColor(Color._8A8E91)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    
                    VStack(alignment: .center) {
                        
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Menu {
                                if let createdByUser = postDetail.createdByUser {
                                    if createdByUser != UserDefaultManger.getName() {
                                        Button(action: {
                                            showReportAlert.toggle()
                                            print("showReportAlert.toggle() from button")
                                        }) {
                                            HStack {
                                                Image(systemName: "exclamationmark.bubble")
                                                Text("Report")
                                                    .font(.muliFont(size: 12, weight: .regular))
                                            }
                                            .frame(width: 50, height: 50)
                                        }
                                        
                                    } else {
                                        Button(action: {
                                            showDeleteAlert.toggle()
                                            print("showDeleteAlert.toggle() from button")
                                        }) {
                                            HStack {
                                                Image(systemName: "trash")
                                                Text("Delete")
                                                    .font(.muliFont(size: 12, weight: .regular))
                                            }
                                            .frame(width: 50, height: 50)
                                        }
                                    }
                                }
                            } label: {
                                Image(ImageConstant.dot)
                                    .frame(width: 30, height: 25)
                            }
                        }
                    }
                    .frame(alignment: .bottom)
                }
            }
            
            .alert(isPresented: Binding<Bool>(get: {
                return showAlert || showReportAlert || showDeleteAlert
            }, set: { newValue in
                if !newValue {
                    showAlert = false
                    showReportAlert = false
                    showDeleteAlert = false
                }
            }), content: {
                if showAlert {
                    return Alert(title: Text(alertTitle), message: Text(errorMessage), dismissButton: .default(Text("Ok")) {
                        if viewModel.isPostDeleted {
                            isPostDeleted = true
                        }
                    })
                } else {
                    if showReportAlert {
                        return Alert(title: Text("Report"), message: Text("Are you sure you want to report?"), primaryButton: .destructive(Text("Yes").foregroundColor(.red)) {
                            viewModel.reportPost(postId: postDetail.postId, reason: "") { result in
                                switch result {
                                case .success(let data):
                                    print(data)
                                    if data.isSucceed ?? false {
                                        errorMessage = data.message ?? ""
                                        showAlert = true
                                    } else {
                                        errorMessage = data.message ?? ""
                                        showAlert = true
                                    }
                                    
                                case .failure(let error):
                                    errorMessage = error.localizedDescription
                                    showAlert = true
                                }
                                
                            }
                        }, secondaryButton: .cancel())
                    } else {
                        return Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this post?"), primaryButton: .destructive(Text("Yes").foregroundColor(.red)) {
                            viewModel.deletePost(postId: postDetail.postId) { result in
                                switch result {
                                case .success(let data):
                                    print(data)
                                    if data.isSucceed ?? false {
                                        errorMessage = "Your post is deleted successfully"
                                        showAlert = true
                                    } else {
                                        errorMessage = data.message ?? ""
                                        showAlert = true
                                    }
                                    
                                case .failure(let error):
                                    errorMessage = error.localizedDescription
                                    showAlert = true
                                }
                                
                            }
                        }, secondaryButton: .cancel())
                    }
                }
            })
            
        }
        .padding(.leading, 3)
    }
}


//#Preview {
//    UserInfoView()
//}
