//
//  UserDefaultManger.swift
//  Complexity
//
//  Created by IE Mac 05 on 07/05/24.
//

import Foundation
struct UserDefaultManger {
    
    static let defaults = UserDefaults.standard
    
    static func saveToken(_ token: String){
        defaults.set(token, forKey: StringConstants.Common.token)
    }
    
    static func getToken() -> String? {
        if let token = defaults.string(forKey: StringConstants.Common.token){
            return token
        }
        return nil
    }
    
    static func saveUserId(_ userId: Int) {
        defaults.set(userId, forKey: StringConstants.UserDefault.userId)
    }
    
    static func getUserId() -> Int? {
        return defaults.integer(forKey: StringConstants.UserDefault.userId)
    }
    
    static func saveName(_ name: String) {
        defaults.set(name, forKey: StringConstants.UserDefault.name)
    }
    
    static func getName() -> String? {
        return defaults.string(forKey: StringConstants.UserDefault.name)
    }
    
    
    static func saveUserName(_ name: String) {
        defaults.set(name, forKey: StringConstants.UserDefault.userName)
    }
    
    static func getUserName() -> String? {
        return defaults.string(forKey: StringConstants.UserDefault.userName)
    }
    
    static func savePlaceId(_ name: String) {
        defaults.set(name, forKey: StringConstants.UserDefault.placeId)
    }
    
    static func getPlaceId() -> String? {
        return defaults.string(forKey: StringConstants.UserDefault.placeId)
    }
    
   
    
    static func getEmail() -> String? {
        return defaults.string(forKey: StringConstants.UserDefault.email)
    }
    
    static func saveEmail(_ name: String) {
        defaults.set(name, forKey: StringConstants.UserDefault.email)
    }
    
    static func getLocation() -> String? {
        return defaults.string(forKey: StringConstants.UserDefault.location)
    }
    
    static func saveLocation(_ name: String) {
        defaults.set(name, forKey: StringConstants.UserDefault.location)
    }
    
    
    
    static func getLatitude() -> Double? {
        return defaults.double(forKey: StringConstants.UserDefault.latitude)
    }
    
    static func saveLatitude(_ value: Double) {
        defaults.set(value, forKey: StringConstants.UserDefault.latitude)
    }
    
    static func getLongitude() -> Double? {
        return defaults.double(forKey: StringConstants.UserDefault.longitude)
    }
    
    static func saveLongitude(_ value: Double) {
        defaults.set(value, forKey: StringConstants.UserDefault.longitude)
    }
    
    static func saveProfilePicture(_ name: String) {
        defaults.set(name, forKey: StringConstants.UserDefault.profileImage)
    }
    
    static func getProfilePicture() -> String? {
        return defaults.string(forKey: StringConstants.UserDefault.profileImage)
    }
    
    static func saveRememberMe(_ rememberMeflag: Bool) {
        defaults.set(rememberMeflag, forKey: StringConstants.UserDefault.rememberMe)
    }
    
    static func getRememberMe() -> Bool? {
        defaults.bool(forKey: StringConstants.UserDefault.rememberMe)
    }
    
    static func saveLoginEmail(_ loginEmail: String) {
        defaults.set(loginEmail, forKey: StringConstants.UserDefault.loginEmail)
    }
    
    static func getLoginEmail() -> String? {
        defaults.string(forKey: StringConstants.UserDefault.loginEmail)
    }
    
    static func saveLoginPassword(_ loginPassword: String) {
        defaults.set(loginPassword, forKey: StringConstants.UserDefault.loginPassword)
    }
    
    static func getLoginPassword() -> String? {
        defaults.string(forKey: StringConstants.UserDefault.loginPassword)
    }
    
    static func clearAllData() {
            let keys = [
                StringConstants.Common.token,
                StringConstants.UserDefault.name,
                StringConstants.UserDefault.location,
                StringConstants.UserDefault.email,
                StringConstants.UserDefault.profileImage,
            ]
            
            keys.forEach { defaults.removeObject(forKey: $0) }
        }
}
