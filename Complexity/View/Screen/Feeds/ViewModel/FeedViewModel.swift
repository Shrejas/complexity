//
//  FeedViewModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 07/05/24.
//

import Foundation
import IQAPIClient
import Alamofire
import GoogleSignIn
import SwiftUI
@MainActor
final class FeedViewModel: ObservableObject {
    
    @Published var feedData: FeedModel?
    @Published var likeData: LikeModel?
    @Published var shouldShowApiAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoding: Bool = false
    @Published var allComment : AllCommentModel?
    @Published var post: FeedPost?
    @Published var notificationData: NotificationModel?
    @Published var notificationPageSize = 10
    @Published var notificationPageIndex: Int = 1
    @Published var userInfo: UserInfo?
    
    func getFeedData(pageIndex: Int, pageSize: Int){
        isLoding = true
        IQAPIClient.getFeed(pageIndex: pageIndex, pageSize: pageSize) { [weak self] rhttpUrlResponse, result  in
            guard let self = self else { return }
            self.isLoding = false
            switch result{
            case .success(let data):
                self.feedData = data
                if data.isSucceed == false {
                    
                }
            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//                self.shouldShowApiAlert.toggle()
                
                getFeedData(pageIndex: 1, pageSize: 10)
            }
        }
    }
    
    func setLike(postId: Int){
        isLoding = true
        IQAPIClient.like(postId: postId) { [weak self] httpUrlResponse, result  in
            guard let self = self else { return }
            self.isLoding = false
            switch result {
            case .success(let data):
                self.likeData = data
                    self.getFeedData(pageIndex: 1, pageSize: 10)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.shouldShowApiAlert.toggle()
            }
        }
    }
    
    func addComment(postId: Int, comment: String){
        isLoding = true
        IQAPIClient.like(postId: postId) { httpUrlResponse, result  in
            self.isLoding = false
            switch result {
            case .success(let data):
                self.likeData = data
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.shouldShowApiAlert.toggle()
            }
        }
    }
    
    func deleteComment(postCommentId: Int){
        isLoding = true
        IQAPIClient.deleteComment(postCommentId: postCommentId) { httpUrlResponse, result  in
            self.isLoding = false
            switch result {
            case .success(let data):
                self.likeData = data
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.shouldShowApiAlert.toggle()
            }
        }
    }
    
    func getAllComment(postId: Int){
        isLoding = true
        IQAPIClient.getAllComment(postId: postId) { httpUrlResponse, result  in
            self.isLoding = false
            switch result {
            case .success(let data):
                self.allComment = data
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.shouldShowApiAlert.toggle()
            }
        }
    }
    
    func getNotification() {
        isLoding = true
        IQAPIClient.getNotification(pageIndex: notificationPageIndex, pageSize: notificationPageSize) { httpURLResponse, result in
            self.isLoding = false
            switch result{
            case .success(let data):
                if var currentData = self.notificationData {
                    currentData += data
                    self.notificationData = currentData
                } else {
                    self.notificationData = data
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.shouldShowApiAlert = true
            }
        }
    }
    
    func getProfileDetail(userId: Int, completionHandler:@escaping (_ result: Swift.Result< UserInfo, Error>) -> Void) -> DataRequest? {
        self.isLoding = true
        return IQAPIClient.getProfile(userId: userId) { httpUrlResponse, result  in
            self.isLoding = false
            switch result {
            case .success(let data):
                self.userInfo = data.userInfo
                completionHandler(.success(data.userInfo))
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.shouldShowApiAlert = true
            }
        }
    }
   
}
