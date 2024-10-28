//
//  ProfileViewModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 05/06/24.
//

import Foundation
import IQAPIClient

@MainActor
final class ProfileViewModel: ObservableObject{
    
    @Published var alertMassage: String = ""
    @Published var alertTitle: String = ""
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var updatePasswordData : ForgotPasswordModel?
    @Published var pageIndex: Int = 1
    @Published var isLoadingMore: Bool = true
    @Published var posts: [FeedPost] = []
    
    func updatePassword(oldPassword: String, newPassword: String) {
        isLoading = true
        IQAPIClient.updatePassword(currentPassword: oldPassword, newPassword: newPassword) { result in
//            self.isLoading = false
            switch result {
            case .success(let data):
                self.updatePasswordData = data
                if data.isSucceed {
                    self.alertTitle = "Success"
                } else {
                    self.alertTitle = "Invalid"
                }
                self.showAlert.toggle()
                self.alertMassage = data.message
            case .failure(let error):
                self.alertMassage = error.localizedDescription
                self.showAlert.toggle()
            }
        }
    }
    
    func deletePost(postId: Int, userId: Int) {
        isLoading = true
        IQAPIClient.deletePost(postId: postId) { httpUrlResponse, result  in
            self.isLoading = false
            switch result {
            case .success(_):
                self.getUserFeed(userId: userId)
                break
            case .failure(let error):
                self.alertMassage = error.localizedDescription
                self.showAlert.toggle()
                break
            }
        }
    }
    
    func getUserFeed(userId: Int, appendData: Bool = false) {
        isLoading = true
        IQAPIClient.getUserFeed(pageIndex: pageIndex, pageSize: 10, userId: userId) { httpUrlResponse, result  in
            self.isLoading = false
            switch result {
            case .success(let data):
                if let newPosts = data.post {
                    if newPosts.count < 10 {
                        self.isLoadingMore = false
                    }
                    if appendData {
                        self.posts.append(contentsOf: newPosts)
                    } else {
                        self.posts = newPosts
                    }
                }
                break
            case .failure(let error):
                self.alertMassage = error.localizedDescription
                self.showAlert.toggle()
                break
            }
        }
    }

    func loadMore(userId: Int) {
        guard isLoadingMore && !isLoading else { return }
        self.pageIndex += 1
        getUserFeed(userId: userId, appendData: true) // Append data when loading more
    }


}
