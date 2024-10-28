//
//  IQAPIClient+APIPath.swift
//  Complexity
//
//  Created by IE Mac 05 on 06/05/24.
//

import Foundation
public enum APIPath: String{
    
#if DEV

    // this is a Devlopment Target
    case baseUrl = "http://devservices.trycomplexity.com/"
#else
    // this is a production Target
    case baseUrl = "http://services.trycomplexity.com/"
#endif
    
    // MARK: - Post
    case getFeedPost = "api/Post/feed"
    case getBrand = "api/Post/drink/brands"
    case getDrinkBrandNames = "api/Post/drink/names/"
    case like = "api/Post/likeunlike/"
    case comment = "api/Post/comment/"
    case newPost = "api/Post/new"
    case userAvailability = "api/User/username/availability/"
    case getPostSearch = "api/Post/search"
    case report = "api/post/report"
    case getNotification = "api/User/notifications"
    case getSearchFeed = "/api/Post/search"
    case getPostLikes = "/api/Post/likes/"

    // MARK: - User
    case signUP = "api/User/signup"
    case getUserUpdate = "api/User/update"
    case login = "api/User/login"
    case forgotPassord = "api/User/password/forgot"
    case resetPassword = "api/User/password/reset"
    case passwordUpdate = "api/User/password/update"
    case deleteProfile = "/api/User/delete"
    case getProfile = "/api/User/profile/"
    case getUserFeed = "/api/Post/user/feed"
    
    // MARK: - Drink
    case getDrinkData = "api/Post/drink/info/"
    case searchDrinks = "/api/Post/drink/search/"
    case getRelatedDrinks = "/api/Post/drink/feed"
    
    case privacyPolicy = "http://services.trycomplexity.com/uploads/privacy-policy.html"
    case termsAndConditions = "http://services.trycomplexity.com/uploads/terms-and-conditions.html"
    
}
