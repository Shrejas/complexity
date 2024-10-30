//
//  IQAPIClient+Feed.swift
//  Complexity
//
//  Created by IE Mac 05 on 10/05/24.
//

import Foundation
import IQAPIClient
import Alamofire
import SwiftUI
extension IQAPIClient{
    
    @discardableResult
    static func getFeed(pageIndex: Int, pageSize: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< FeedModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getFeedPost.rawValue
        let parameters: [String: Any] = ["pageIndex": pageIndex,
                                   "pageSize": pageSize]
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, parameters: parameters, encoding: JSONEncoding.default) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    @discardableResult
    static func getSearchFeed(pageIndex: Int?, pageSize: Int?, placeID: String? = nil, drinkName: String? = nil, searchKeyword:String?, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< FeedModel, Error>) -> Void) -> DataRequest? {
        
        let path = APIPath.getSearchFeed.rawValue
        var parameters: [String: Any] = [:]
            
            if let pageIndex = pageIndex, pageIndex > 0 {
                parameters["pageIndex"] = pageIndex
            }
            
            if let pageSize = pageSize, pageSize > 0 {
                parameters["pageSize"] = pageSize
            }
            
            if let placeID = placeID, !placeID.isEmpty {
                parameters["placeID"] = placeID
            }
                parameters["drinkName"] = "hein"
        
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, parameters: parameters, encoding: JSONEncoding.default) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    

    @discardableResult
    static func getFeedWithPlaceId(placeId: String,drinkName: String, pageIndex: Int, pageSize: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< FeedModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getPostSearch.rawValue
        let parameters: [String: Any] = ["pageIndex": pageIndex,
                                         "pageSize": pageSize,
                                               "placeId": placeId,
                                               "drinkName": drinkName]
        
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, parameters: parameters, encoding: JSONEncoding.default ,completionHandler: { httpURLResponse,result in
            completionHandler(httpURLResponse, result)
        })
    }
    
    @discardableResult
    static func reportPost(postId: Int, reason: String , completionHandler: @escaping ( _ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< FeedModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.report.rawValue
        let parameters: [String: Any] = ["postId": postId,
                                         "reason": reason ]
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, parameters: parameters, encoding: JSONEncoding.default ,completionHandler: completionHandler)
    }
    

    @discardableResult
    static func getBrands(completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< BrandModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getBrand.rawValue
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .get, completionHandler: completionHandler)
    }
    
    @discardableResult
    static func getDrinkName(brandName: String, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< DrinkModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getDrinkBrandNames.rawValue + brandName
        
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .get, completionHandler: completionHandler)
    }
    
    @discardableResult
    static func newPost(postId: Int, drinkName: String, drinkBrand: String, drinkCategory: String, drinkSubCategory: String, caption: String, rating: Int, location: String, latitude:String, longitude: String, placeId: String,  image: [UIImage],     completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result<NewPostModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.newPost.rawValue
        var param: [String: Any] = [ "postId": postId,
                                     "drinkName" : drinkName,
                                     "brandName": drinkBrand,
                                     "drinkCategory": drinkCategory,
                                     "drinkSubCategory": drinkSubCategory,
                                     "caption": caption,
                                     "rating": rating,
                                     "location": location,
                                     "latitude": latitude,
                                     "longitude": longitude,
                                     "placeid": placeId,
        ]
        
        if image.count > 0{
            var files: [File] = []
            for (index, image) in image.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    let imageFile = File(data: imageData, mimeType: "image/jpeg", fileName: "post_image_\(index).jpg")
                    files.append(imageFile)
                    
                }
            }
            param["media"] = files
            
        }
        
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, parameters: param, forceMultipart: true, completionHandler: completionHandler)
    }
    
    
    @discardableResult
    static func like(postId: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result<LikeModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.like.rawValue + "\(postId)"
        let para: [String: Any] = ["postId" : postId]
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, parameters: para, completionHandler: completionHandler)
        
    }
    
    @discardableResult
    static func addComment(postId: Int, comment: String, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result<CommentResponseModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.comment.rawValue
        let para: [String: Any] = ["postId" : postId, "comment": comment]
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, parameters: para, encoding: JSONEncoding.default, completionHandler: completionHandler)
        
    }
    
    @discardableResult
    static func deleteComment(postCommentId: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result<LikeModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.comment.rawValue + "\(postCommentId)"
        let para: [String: Any] = ["postCommentId" : postCommentId]
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .delete, parameters: para, completionHandler: completionHandler)
        
    }
    
    @discardableResult
    static func deleteProfile(completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result<DeleteProfileModel, Error>) -> Void) -> DataRequest{
        let path = APIPath.deleteProfile.rawValue
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .delete, completionHandler: completionHandler)
    }


    @discardableResult
    static func getAllComment(postId: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result<AllCommentModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.comment.rawValue + "\(postId)"
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .get, parameters: nil, completionHandler: completionHandler)
        
    }
    
    @discardableResult
    static func getNotification(pageIndex: Int, pageSize: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< NotificationModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getNotification.rawValue
        let parameters: [String: Any] = ["pageIndex": pageIndex,
                                         "pageSize": pageSize]
        
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, parameters: parameters, encoding: JSONEncoding.default) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    @discardableResult
    static func readNotification(id: Int? = nil, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< NotificationModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.readNotification.rawValue
        var parameters: [String: Any] = [:]
        if let id = id {
            parameters["id"] = id
        }
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .put, parameters: parameters, encoding: URLEncoding.queryString) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    @discardableResult
    static func getPostLikes(postId: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< PostLikes, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getPostLikes.rawValue + "\(postId)"
                                         
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, encoding: JSONEncoding.default) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    @discardableResult
    static func getProfile(userId: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< User, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getProfile.rawValue + "\(userId)"
                                   
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .get, encoding: JSONEncoding.default) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    @discardableResult
    static func getUserFeed(pageIndex: Int, pageSize: Int, userId: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< FeedModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getUserFeed.rawValue
        let parameters: [String: Any] = ["pageIndex": pageIndex,
                                         "pageSize": pageSize,
                                         "userId": userId]
                                   
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, parameters: parameters, encoding: JSONEncoding.default) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    @discardableResult
    static func getDrinkData(drinkId: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< Drink, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getDrinkData.rawValue + "\(drinkId)"
                                   
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .get, encoding: JSONEncoding.default) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    @discardableResult
    static func getSearchDrinkData(drinkName: String, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< SearchedDrinks, Error>) -> Void) -> DataRequest? {
        let path = APIPath.searchDrinks.rawValue + "\(drinkName)"
                                   
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .get, encoding: JSONEncoding.default) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    @discardableResult
    static func getRelatedDrinksFeed(drinkId: Int, pageIndex: Int, pageSize: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< RelatedDrinksFeed, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getRelatedDrinks.rawValue
        let parameters: [String: Any] = ["drinkId": drinkId,
                                         "pageIndex": pageIndex,
                                         "pageSize": pageSize]
        
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .post, parameters: parameters,encoding: JSONEncoding.default) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    @discardableResult
    static func deletePost(postId: Int, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result<FeedModel, Error>) -> Void) -> DataRequest? {
        let path = "\(postId)"
        
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .delete) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
        
    }
}
