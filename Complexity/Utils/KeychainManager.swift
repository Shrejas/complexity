//
//  KeychainManager.swift
//  Complexity
//
//  Created by IE Mac 05 on 06/06/24.
//

import Foundation
import KeychainSwift

struct KeychainManager {
    
    private static let keychain = KeychainSwift()
    
    static func saveToken(_ token: String) {
        keychain.set(token, forKey: StringConstants.Common.token)
    }
    
    static func getToken() -> String? {
        return keychain.get(StringConstants.Common.token)
    }
}
