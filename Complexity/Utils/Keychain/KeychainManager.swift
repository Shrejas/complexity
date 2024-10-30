//
//  KeychainManager.swift
//  Complexity
//
//  Created by IE Mac 05 on 09/05/24.
//

import Foundation
import KeychainSwift

struct KeychainManager{
    private static let keychain = KeychainSwift()
    
    static var email: String? {
            get {
                return keychain.get("email")
            }
            set(newEmail) {
                if let email = newEmail {
                    keychain.set(email, forKey: "email")
                } else {
                    keychain.delete("email")
                }
            }
        }
    
    static var appleId: String? {
            get {
                return keychain.get("appleId")
            }
            set(newEmail) {
                if let email = newEmail {
                    keychain.set(email, forKey: "appleId")
                } else {
                    keychain.delete("appleId")
                }
            }
        }
    
    static var firstName: String? {
            get {
                return keychain.get("FirstName")
            }
            set(newEmail) {
                if let email = newEmail {
                    keychain.set(email, forKey: "FirstName")
                } else {
                    keychain.delete("FirstName")
                }
            }
        }
    
    static var lastName: String? {
            get {
                return keychain.get("LastName")
            }
            set(newEmail) {
                if let email = newEmail {
                    keychain.set(email, forKey: "LastName")
                } else {
                    keychain.delete("LastName")
                }
            }
        }
    
   
    static var token: String? {
        get {
            return keychain.get(StringConstants.Common.deviceToken)
        }
        set {
            if let token = newValue {
                keychain.set(token, forKey: StringConstants.Common.deviceToken)
            } else {
                keychain.delete(StringConstants.Common.deviceToken)
            }
        }
    }
    
}
