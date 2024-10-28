//
//  DeleteProfileModel.swift
//  Complexity
//
//  Created by IE12 on 01/07/24.
//

import Foundation
struct DeleteProfileModel: Codable {
    let isSucceed : Bool
    let message: String

    private enum CodingKeys: String, CodingKey {
        case isSucceed = "isSucceed"
        case message = "message"
    }
}
