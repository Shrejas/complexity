//
//  LoginViewModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 07/05/24.
//

import Foundation
import IQAPIClient
import GoogleSignIn
import AuthenticationServices

struct UserDetail {
    let email: String
    let givenName: String
    let socialMediaAccountId: String
}

@MainActor
final class LoginViewModel: NSObject, ObservableObject{
    @Published var loginData: LoginModel?
    var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var shouldShowApiAlert: Bool = false
    @Published var userDetail: UserDetail?
    @Published var isSucced: Bool = false
    
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
    
    func doLogin(userName: String, password: String, socialMediaPaltform: String,socialMediaAccountId: String, deviceType: String, deviceId: String, timezone: String){
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
                if data.isSucceed {
                    self.isSucced.toggle()
                } else {
                    self.shouldShowApiAlert = !data.isSucceed
                    self.errorMessage = data.message
                }
                
               
                break
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.shouldShowApiAlert.toggle()
                break
            }
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
                self.doLogin(userName: UserDetail.email, password: "", socialMediaPaltform: StringConstants.Common.google, socialMediaAccountId: UserDetail.socialMediaAccountId, deviceType: self.deviceType, deviceId: self.deviceId, timezone: self.timeZone)
            }
        }
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
    }
}
extension LoginViewModel: ASAuthorizationControllerDelegate {
    
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
            
            self.doLogin(userName: email ?? "", password: "", socialMediaPaltform: StringConstants.Common.apple, socialMediaAccountId: userid , deviceType: deviceType, deviceId: deviceId, timezone: timeZone)
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
