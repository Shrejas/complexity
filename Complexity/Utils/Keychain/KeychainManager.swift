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


//class KeychainManager {
//    static let shared = KeychainManager()
//
//    private init() {}
//
//    func save(key: String, data: Data) -> Bool {
//        let query = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: key,
//            kSecValueData as String: data
//        ] as [String : Any]
//
//        SecItemDelete(query as CFDictionary)
//
//        let status = SecItemAdd(query as CFDictionary, nil)
//        return status == errSecSuccess
//    }
//
//    func load(key: String) -> Data? {
//        let query = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: key,
//            kSecReturnData as String: kCFBooleanTrue!,
//            kSecMatchLimit as String: kSecMatchLimitOne
//        ] as [String : Any]
//
//        var dataTypeRef: AnyObject? = nil
//        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
//
//        if status == errSecSuccess {
//            return dataTypeRef as? Data
//        } else {
//            return nil
//        }
//    }
//
//    func delete(key: String) -> Bool {
//        let query = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: key
//        ] as [String : Any]
//
//        let status = SecItemDelete(query as CFDictionary)
//        return status == errSecSuccess
//    }
//
//    var token: String? {
//        guard let tokenData = load(key: "FCMToken"), let token = String(data: tokenData, encoding: .utf8) else {
//            return nil
//        }
//        return token
//    }
//}
