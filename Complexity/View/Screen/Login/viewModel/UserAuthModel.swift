//
//  UserAuthModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 21/06/24.
//

import Foundation
import SwiftUI
import GoogleSignIn
import IQAPIClient
import AuthenticationServices

class UserAuthModel: NSObject, ObservableObject {
    
    @Published var shouldShowApiAlert: Bool = false
    @Published var loginData: LoginModel?
    @Published var signUpData: SignUPModel?
    @Published var givenName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    @Published var isSucced: Bool = false
    @Published var isLoading: Bool = false
    var timeZone: String {
        let timeZone = TimeZone.current
        let timeZoneName = timeZone.identifier
        return timeZoneName
    }
    
    var deviceType: String = StringConstants.Common.deviceType
    
    var deviceId: String {
        let deviceId = KeychainManager.token ?? ""
        return deviceId
    }
    
    override init() {
        super.init()
        self.checkStatus { _ in 
        }
    }

    
    func checkStatus(completion: @escaping (UserDetail) -> Void) {
        if let currentUser = GIDSignIn.sharedInstance.currentUser {
            let givenName = currentUser.profile?.givenName ?? ""
            guard let email = currentUser.profile?.email else { return  }
            let accountId = currentUser.userID ?? ""
            let userDetail = UserDetail(email: email, givenName: givenName, socialMediaAccountId: accountId)
            completion(userDetail)
        } else {
            let userDetail = UserDetail(email: "", givenName: "", socialMediaAccountId: "")
            completion(userDetail)
        }
    }
    
    
    func loginWithGoogle() {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error{
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            
            self.checkStatus { UserDetail in
                self.doLogin(userName: UserDetail.email, password: "", socialMediaPaltform: StringConstants.Common.google, socialMediaAccountId: UserDetail.socialMediaAccountId, deviceType: self.deviceType, deviceId: self.deviceId, timezone: self.timeZone){ result in
                    switch result{
                    case .success(let data):
                        if !data.isSucceed{
                            
                            self.doSignUP(name: UserDetail.givenName, email: UserDetail.email, userName: UserDetail.givenName, password: "", location: "", latitude: "", longitude: "", placeId: "", socialMediaAccountId: UserDetail.socialMediaAccountId, SocialMediaPlatform: StringConstants.Common.google, deviceType: self.deviceType, deviceId: self.deviceId, timeZone: self.timeZone)
                        }
                        break
                    case .failure(_):
                        break
                    }
                }
            }
        }
    }
    
    
    func doLogin(userName: String, password: String, socialMediaPaltform: String,socialMediaAccountId: String, deviceType: String, deviceId: String, timezone: String,  completionHandler: @escaping (_ result: Swift.Result<LoginModel, Error>) -> Void) {
        isLoading = true
        IQAPIClient.login(userName: userName, password: password, socialMediaPaltform: socialMediaPaltform, socialMediaAccountId: socialMediaAccountId, deviceType: deviceType, deviceId: deviceId, timezone: timezone) { result in
            self.isLoading = false
            switch result{
                
            case .success(let data):
                self.loginData = data
                UserDefaultManger.saveToken(self.loginData?.token ?? "")
                UserDefaultManger.saveName(self.loginData?.userInfo?.name ?? "")
                UserDefaultManger.saveUserId(self.loginData?.userInfo?.userId ?? 0)
                UserDefaultManger.saveUserName(self.loginData?.userInfo?.userName ?? "")
                UserDefaultManger.saveLocation(self.loginData?.userInfo?.location ?? "")
                if let profilePicture = self.loginData?.userInfo?.profilePicture {
                    UserDefaultManger.saveProfilePicture(profilePicture)
                }
                UserDefaultManger.saveEmail(self.loginData?.userInfo?.email ?? "")
                if let latitudeString = data.userInfo?.latitude, let latitude = Double(latitudeString) {
                    UserDefaultManger.saveLatitude(latitude)
                }
                
                if let longitudeString = data.userInfo?.longitude, let longitude = Double(longitudeString) {
                    UserDefaultManger.saveLongitude(longitude)
                }
                if data.isSucceed{
                    self.isSucced.toggle()
                }
                completionHandler(.success(data))
                break
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.shouldShowApiAlert.toggle()
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    func doSignUP(name: String, email: String, userName: String, password: String, location: String, latitude: String, longitude: String, placeId: String, socialMediaAccountId: String,
                  SocialMediaPlatform: String, deviceType: String, deviceId: String, timeZone: String){
        isLoading = true
        IQAPIClient.signUP(name: name, email: email, userName: userName, password: password, location: location, latitude: latitude, longitude: longitude, placeId: placeId, socialMediaAccountId: socialMediaAccountId, SocialMediaPlatform: SocialMediaPlatform, deviceType: deviceType, deviceID: deviceId, timezone: timeZone){ result in
            self.isLoading = false
            switch result{
                
            case .success(let data):
                self.signUpData = data
                
                UserDefaultManger.saveToken(self.signUpData?.token ?? "")
                UserDefaultManger.saveName(self.signUpData?.userInfo?.name ?? "")
                UserDefaultManger.saveUserId(self.signUpData?.userInfo?.userId ?? 0)
                UserDefaultManger.saveUserName(self.signUpData?.userInfo?.userName ?? "")
                UserDefaultManger.saveLocation(self.signUpData?.userInfo?.location ?? "")
                UserDefaultManger.saveProfilePicture(self.signUpData?.userInfo?.profilePicture ?? "")
                UserDefaultManger.saveEmail(self.signUpData?.userInfo?.email ?? "")
                if let latitudeString = data.userInfo?.latitude, let latitude = Double(latitudeString) {
                    UserDefaultManger.saveLatitude(latitude)
                }
                
                if let longitudeString = data.userInfo?.longitude, let longitude = Double(longitudeString) {
                    UserDefaultManger.saveLongitude(longitude)
                }
                if data.isSucceed {
                    UserDefaultManger.saveToken(self.signUpData?.token ?? "")
                    self.isSucced.toggle()
                } else {
                    self.shouldShowApiAlert.toggle()
                    self.errorMessage = data.message
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print(self.errorMessage)
                self.shouldShowApiAlert.toggle()
                break
            }
        }
    }
}

extension UserAuthModel: ASAuthorizationControllerDelegate {
    
    func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
  
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userid = appleIDCredential.user
            let email = appleIDCredential.email ?? KeychainManager.email
            let firstName = appleIDCredential.fullName?.givenName ?? KeychainManager.firstName
            let lastName = appleIDCredential.fullName?.familyName ?? KeychainManager.lastName
            let fullName = "\(firstName ?? "") \(lastName ?? "")"
            
            KeychainManager.firstName = firstName
            KeychainManager.lastName = lastName
            KeychainManager.email = email
            KeychainManager.appleId = userid
            
            self.doLogin(userName: email ?? "", password: "", socialMediaPaltform: StringConstants.Common.apple, socialMediaAccountId: userid , deviceType: deviceType, deviceId: deviceId, timezone: timeZone){ result in
                switch result{
                case .success(let data):
                    if !data.isSucceed{
                        
                        self.doSignUP(name: fullName, email: email ?? "" , userName: email ?? "", password: "", location: "", latitude: "", longitude: "", placeId: "", socialMediaAccountId: userid  , SocialMediaPlatform: StringConstants.Common.apple, deviceType: self.deviceType, deviceId: self.deviceId, timeZone: self.timeZone)
                    }
                    break
                case .failure(_):
                    break
                }
            }
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error during authorization
        print("Authorization Error: \(error.localizedDescription)")
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                print("Authorization canceled by user.")
            case .unknown:
                print("Unknown error occurred.")
            case .invalidResponse:
                print("Invalid response received.")
            case .notHandled:
                print("Authorization request not handled.")
            case .failed:
                print("Authorization request failed.")
            @unknown default:
                print("Unhandled error code.")
            }
        }
    }
    
}
