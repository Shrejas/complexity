//
//  ForgotPasswordModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 07/05/24.
//

import Foundation
struct ForgotPasswordModel: Codable{
    
    let isSucceed: Bool
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case isSucceed = "isSucceed"
        case message = "message"
    }
}
