//
//  UserAuthModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 08/05/24.
//

import Foundation
import SwiftUI
import GoogleSignIn
import AuthenticationServices

@MainActor
class AppViewModel: ObservableObject{
    
        @Published var isLoggedIn: Bool = false
       @Published var token: String?

       func login(token: String) {
           self.token = token
           self.isLoggedIn = true
       }

       func logout() {
           UserDefaults.standard.removeObject(forKey: StringConstants.Common.token)
           self.token = UserDefaultManger.getToken()
           self.isLoggedIn = false
       }
    
}
