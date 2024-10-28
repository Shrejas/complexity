//
//  SignUP.swift
//  Complexity
//
//  Created by IE Mac 05 on 06/05/24.
//

import Foundation
struct SignUPModel: Codable {

    let token: String?
    let userInfo: UserInfoo?
    let isSucceed: Bool
    let message: String

    private enum CodingKeys: String, CodingKey {
        case token = "token"
        case userInfo = "userInfo"
        case isSucceed = "isSucceed"
        case message = "message"
    }

}

struct UserInfoo: Codable {

    let userId: Int
    let userIdentifier: String
    let name: String
    let email: String
    let userName: String
    let profilePicture: String
    let location: String
    let latitude: String
    let longitude: String
    let placeId: String

    private enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case userIdentifier = "userIdentifier"
        case name = "name"
        case email = "email"
        case userName = "userName"
        case profilePicture = "profilePicture"
        case location = "location"
        case latitude = "latitude"
        case longitude = "longitude"
        case placeId = "placeId"
    }
    

}

struct UserNameAvailabilityModel: Codable{
    let isSucceed: Bool
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case isSucceed = "isSucceed"
        case message = "message"
    }
}
