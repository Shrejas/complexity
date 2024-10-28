//
//  FeedViewCellViewModel.swift
//  Complexity
//
//  Created by IE MacBook Pro 2014 on 27/05/24.
//

import Foundation
import IQAPIClient
import SwiftUI

@MainActor
final class FeedViewCellViewModel: ObservableObject {
    
    @Published var reportResult: FeedModel?
    @Published var isLoading: Bool = false
    @Published var isPostDeleted: Bool = false
    

    func reportPost(postId: Int, reason: String, completion: @escaping (_ result: Swift.Result< FeedModel, Error>) -> Void) {
        isLoading = true
        IQAPIClient.reportPost(postId: postId, reason: reason) { httpUrlResponse, result  in
            self.isLoading = false
            switch result {
            case .success(let data):
                self.reportResult = data
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deletePost(postId: Int, completion: @escaping (_ result: Swift.Result< FeedModel, Error>) -> Void) {
        isLoading = true
        IQAPIClient.deletePost(postId: postId) { httpUrlResponse, result  in
            self.isLoading = false
            switch result {
            case .success(let data):
                self.isPostDeleted = true
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
