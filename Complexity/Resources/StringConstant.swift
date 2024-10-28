//
//  StringConstant.swift
//  Complexity
//
//  Created by IE Mac 05 on 06/05/24.
//

import Foundation
internal struct StringConstants {
    
    struct APIError {
        static let serverError = "Server Error"
        static let tokenHasExpired = "Token has expired"
        static let clientError = "Client Error"
        static let invalidCredential = "Invalid credentials provided."
        static let clientErrorMessage = "Client Error"
        static let serverErrorMessage  = "Server Error"
    }
    
    public struct APIConstant {
        public static let platform  = "ios"
    }
    struct Common {
        static let token = "Token"
        static let deviceToken = "DeviceToken"
        static let google = "google"
        static let apple = "apple"
        static let deviceType = "ios"
    }
    
    struct NotificationName {
        static let sessionExpiredNotificationKey = "sessionExpiredNotification"
        static let userLogoutNotificationKey = "kUserLogoutNotification"
        static let callRefreshMethod = "CallRefreshMethod"
    }
    
    struct UserDefault {
        
        static let userId = "userId"
        static let name = "name"
        static let userName = "userName"
        static let profileImage = "ProfileImage"
        static let location = "location"
        static let email = "Email"
        static let rememberMe = "RememberMe"
        static let loginEmail = "LoginEmail"
        static let loginPassword = "loginPassword"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let placeId = "placeId"
    }
    
    struct GoogleAPIKey{
        static var key = "AIzaSyC50bMU0ZA9Ht55D3GbIWu6KtYZaEfsUA4"
    }
    
}
