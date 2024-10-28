//
//  NewPostModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 10/05/24.
//

import Foundation
struct NewPostModel: Codable {

    let post: Post?
    let isSucceed: Bool
    let message: String

}

struct Post: Codable {

    let postId: Int
    let drinkName: String
    let drinkBrand: String
    let drinkCategory: String
    let drinkSubCategory: String
    let caption: String
    let rating: Int
    let location: String
    let latitude: String
    let longitude: String
    let placeId: String
    let media: [String]

}
