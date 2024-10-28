//
//  ProfileModel.swift
//  Complexity
//
//  Created by IE Mac 03 on 16/07/24.
//

import Foundation

struct User: Codable {
    let userInfo: UserInfo
}

struct UserInfo: Codable, Equatable {

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

}
