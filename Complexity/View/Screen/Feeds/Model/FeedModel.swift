//
//  FeedModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 07/05/24.
//

import Foundation

struct FeedModel: Codable, Equatable {

    var post: [FeedPost]?
    let isSucceed: Bool?
    let message: String?
    var searchText: String?
    var badgeCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case post = "post"
        case isSucceed = "isSucceed"
        case message = "message"
        case badgeCount = "badgeCount"
    }

}

struct FeedPost: Codable, Equatable, Identifiable, Hashable {

    var id: Int { postId }

    let createdBy: Int?
    let createdByUser: String?
    let createdByUserProfilePicture: String?
    let createdAt: String?
    let createdTime: String?
    var likedByMe: Bool
    var likeCount: Int
    var commentCount: Int
    var recentComment: Comment?
    let postId: Int
    let drinkName: String?
    let drinkBrand: String?
    let drinkCategory: String?
    let drinkSubCategory: String?
    let caption: String?
    let rating: Int?
    let location: String?
    let latitude: String?
    let longitude: String?
    let placeId: String
    let media: [String]?

    private enum CodingKeys: String, CodingKey {
        case createdBy = "createdBy"
        case createdByUser = "createdByUser"
        case createdByUserProfilePicture = "createdByUserProfilePicture"
        case createdAt = "createdAt"
        case createdTime = "createdTime"
        case likedByMe = "likedByMe"
        case likeCount = "likeCount"
        case commentCount = "commentCount"
        case recentComment = "recentComment"
        case postId = "postId"
        case drinkName = "drinkName"
        case drinkBrand = "drinkBrand"
        case drinkCategory = "drinkCategory"
        case drinkSubCategory = "drinkSubCategory"
        case caption = "caption"
        case rating = "rating"
        case location = "location"
        case latitude = "latitude"
        case longitude = "longitude"
        case placeId = "placeId"
        case media = "media"
    }
    static func ==(lhs: FeedPost, rhs: FeedPost) -> Bool {
            return lhs.postId == rhs.postId // Compare based on unique identifier
        }

}
struct RecentComment: Codable {

    let postCommentId: Int?
    let comment: String?
    let createdByUser: String?
    let createdBy: Int?
    let createByUserProfilePicture: String?
    let createdAt: String?
    let createdTime: String?

    private enum CodingKeys: String, CodingKey {
        case postCommentId = "postCommentId"
        case comment = "comment"
        case createdByUser = "createdByUser"
        case createdBy = "createdBy"
        case createByUserProfilePicture = "createByUserProfilePicture"
        case createdAt = "createdAt"
        case createdTime = "createdTime"
    }
}

struct LikeModel: Codable {
    let isSucceed : Bool
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case isSucceed = "isSucceed"
        case message = "message"
    }
}

struct AllCommentModel: Codable {

    let comment: [Comment]
    let isSucceed: Bool
    let message: String

    private enum CodingKeys: String, CodingKey {
        case comment = "comment"
        case isSucceed = "isSucceed"
        case message = "message"
    }

}

struct CommentResponseModel: Codable {

    let comment: Comment?
    let isSucceed: Bool
    let message: String

    private enum CodingKeys: String, CodingKey {
        case comment = "comment"
        case isSucceed = "isSucceed"
        case message = "message"
    }
}

struct Comment: Codable , Hashable{

    let postCommentId: Int
    let comment: String
    let createdByUser: String
    let createdBy: Int
    let createByUserProfilePicture: String
    let createdAt: String
    let createdTime: String

    private enum CodingKeys: String, CodingKey {
        case postCommentId = "postCommentId"
        case comment = "comment"
        case createdByUser = "createdByUser"
        case createdBy = "createdBy"
        case createByUserProfilePicture = "createByUserProfilePicture"
        case createdAt = "createdAt"
        case createdTime = "createdTime"
    }

}

struct PostLikes: Codable {
    let likes: [Likes]
}


struct Likes: Codable {

    let userId: Int
    let name: String
    let profilePicture: String
    let likedAt: String

}

struct Feeds: Codable {
    let post: [Post]
}


