//
//  LoginModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 07/05/24.
//

import Foundation
struct LoginModel: Codable {

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
