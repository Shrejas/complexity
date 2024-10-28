//
//  IQAPIClient+Login.swift
//  Complexity
//
//  Created by IE Mac 05 on 06/05/24.
//

import Foundation
import IQAPIClient
import Alamofire


extension IQAPIClient {
    
    @discardableResult
    static func signUP(name: String, email: String, userName: String, password: String, location: String, latitude: String, longitude: String, placeId: String, socialMediaAccountId: String,
                       SocialMediaPlatform: String, deviceType: String, deviceID: String, timezone: String, completionHandler: @escaping (_ result: Swift.Result<SignUPModel, Error>) -> Void) -> DataRequest? {
        guard NetworkManager.isReachable() else {
            let error = NSError(domain: StringConstants.APIError.clientError, code: NSURLErrorBadServerResponse, userInfo: [NSLocalizedDescriptionKey: "Please check your internet connection."])
            completionHandler(.failure(error))
            return nil
        }
        let path = APIPath.signUP.rawValue
        let param: [String: Any] = ["name": name,
                                    "email": email,
                                    "username": userName,
                                    "password": password,
                                    "location": location,
                                    "latitude": latitude,
                                    "longitude": longitude,
                                    "placeId": placeId,
                                    "socialMediaAccountId": socialMediaAccountId,
                                    "socialMediaPlatform": SocialMediaPlatform,
                                    "deviceType": deviceType,
                                    "deviceId": deviceID,
                                    "timezone": timezone]
        return IQAPIClient.default.sendRequest(path: path, method: .post, parameters: param, completionHandler: completionHandler)
    }
    
    
    @discardableResult
    static func login(userName: String, password: String, socialMediaPaltform: String,socialMediaAccountId: String, deviceType: String, deviceId: String, timezone: String,  completionHandler: @escaping (_ result: Swift.Result<LoginModel, Error>) -> Void) -> DataRequest? {
        
        let path = APIPath.login.rawValue
        let param: [String: Any] = ["username": userName,
                                   "password": password,
                                   "socialMediaPlatform": socialMediaPaltform,
                                   "socialMediaAccountId": socialMediaAccountId,
                                    "deviceType": deviceType,
                                    "deviceId": deviceId,
                                    "timezone": timezone]
        return IQAPIClient.default.sendRequest(path: path, method: .post, parameters: param, completionHandler: completionHandler)
    }
    
    @discardableResult
    static func userUpdate(name: String = "", email: String = "", userName: String = "", password: String = "", location: String = "", latitude: String = "", longitude: String = "", placeId: String = "", socialMediaAccountId: String = "", socialMediaPlatform: String = "", profilePicture: UIImage?, completionHandler: @escaping (_ httpURLResponse: HTTPURLResponse ,_ result: Swift.Result< SignUPModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.getUserUpdate.rawValue
        var param: [String: Any] = [:]
         
        if !name.isEmpty {
             param["Name"] = name
         }
        if  !email.isEmpty {
             param["Email"] = email
         }
        if !userName.isEmpty {
             param["UserName"] = userName
         }
        if !password.isEmpty {
             param["Password"] = password
         }
        if !location.isEmpty {
             param["Location"] = location
         }
        if !latitude.isEmpty {
             param["Latitude"] = latitude
         }
        if !longitude.isEmpty {
             param["Longitude"] = longitude
         }
        if  !placeId.isEmpty {
             param["PlaceId"] = placeId
         }
        if !socialMediaAccountId.isEmpty {
             param["SocialMediaAccountId"] = socialMediaAccountId
         }
        if !socialMediaPlatform.isEmpty {
             param["SocialMediaPlatform"] = socialMediaPlatform
         }
         
         if let imageData = profilePicture?.jpegData(compressionQuality: 0.5) {
             let imageFile = File(data: imageData, mimeType: "image/jpeg", fileName: "profile_image.jpg")
             param["profilePicture"] = imageFile
         }
                                      
        
        return IQAPIClient.default.refreshableSendRequest(path: path, method: .put, parameters: param, encoding: JSONEncoding.default, options: .forceMultipart) { httpURLResponse, result in
            completionHandler(httpURLResponse, result)
        }
    }
    
    
    @discardableResult
    static func forgotPassword(userName: String, completionHandler: @escaping (_ result: Swift.Result<ForgotPasswordModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.forgotPassord.rawValue
        let param: [String: Any] = ["username": userName]
        return IQAPIClient.default.sendRequest(path: path, method: .post,parameters: param, completionHandler: completionHandler)
    }
    
    @discardableResult
    static func resetPassword(userName: String,otp: Int, newPassword: String, completionHandler: @escaping (_ result: Swift.Result<ForgotPasswordModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.resetPassword.rawValue
        let param: [String: Any] = ["userName": userName,
                                    "otp": otp,
                                    "newPassword": newPassword]
        return IQAPIClient.default.sendRequest(path: path, method: .post,parameters: param, completionHandler: completionHandler)
    }
    
    @discardableResult
    static func updatePassword(currentPassword: String, newPassword: String, completionHandler: @escaping (_ result: Swift.Result<ForgotPasswordModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.passwordUpdate.rawValue
        let param: [String: Any] = ["currentPassword": currentPassword,
                                    "newPassword": newPassword]
        return IQAPIClient.default.sendRequest(path: path, method: .post,parameters: param, completionHandler: completionHandler)
    }
    
    @discardableResult
    static func userNameAvailability(userName: String, completionHandler: @escaping (_ result: Swift.Result<UserNameAvailabilityModel, Error>) -> Void) -> DataRequest? {
        let path = APIPath.userAvailability.rawValue + userName
        return IQAPIClient.default.sendRequest(path: path, method: .get, completionHandler: completionHandler)
    }
    
   
}
