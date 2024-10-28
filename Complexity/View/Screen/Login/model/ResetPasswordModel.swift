//
//  VerificationModel.swift
//  Complexity
//
//  Created by IE12 on 10/05/24.
//

import Foundation

struct ResetPasswordModel: Codable {

    let username: String
    let otp: Int
    let newPassword: String

}
