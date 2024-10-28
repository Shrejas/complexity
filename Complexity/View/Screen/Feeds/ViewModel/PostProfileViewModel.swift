//
//  PostProfileViewModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 30/07/24.
//

import SwiftUI
import UIKit
import IQAPIClient

@MainActor
final class PostProfileViewModel: ObservableObject {
    
    @Published public var isLoading: Bool = false
    @Published public var showAlert: Bool = false
    @Published public var isLoadingMore: Bool = true
    @Published public var isLoadMoreProcess: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var pageIndex: Int = 1
    @Published public var posts: [FeedPost] = []
    
    
    public func getUserFeed(userId: Int) {
        isLoading = true
        IQAPIClient.getUserFeed(pageIndex: pageIndex, pageSize: 10, userId: userId) { httpUrlResponse, result  in
            self.isLoading = false
            switch result {
            case .success(let data):
                if let newPosts = data.post {
                    if newPosts.count < 10 {
                        self.isLoadingMore = false
                    }
                    self.posts.append(contentsOf: newPosts)
                    self.pageIndex += 1
                }
                break
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlert.toggle()
                break
            }
        }
    }
    
    public func loadMore(userId: Int) {
        guard isLoadingMore && !isLoading else { return }
        getUserFeed(userId: userId)
    }
}


