//
//  NewPostViewModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 10/05/24.
//

import Foundation
import IQAPIClient
import SwiftUI

@MainActor
final class NewPostViewModel: ObservableObject{
    
    @Published var newPostData: NewPostModel?
    @Published var isLoading: Bool = false

    func newPost(postId: Int, drinkName: String, drinkBrand: String, drinkCategory: String, drinkSubCategory: String, caption: String, rating: Int, location: String, latitude: String, longitude: String, placeId: String, image: [UIImage],completion: @escaping (_ result: Swift.Result<NewPostModel, Error>) -> Void) {
        isLoading = true
        IQAPIClient.newPost(postId: postId, drinkName: drinkName, drinkBrand: drinkBrand, drinkCategory: drinkCategory, drinkSubCategory: drinkSubCategory, caption: caption, rating: rating, location: location, latitude: latitude, longitude: longitude, placeId: placeId, image: image) { httpUrlResponse ,result  in
            self.isLoading = false
            switch result {
            case .success(let data):
                self.newPostData = data
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
