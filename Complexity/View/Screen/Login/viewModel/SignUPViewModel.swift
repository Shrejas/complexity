//
//  ViewModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 06/05/24.
//

import Foundation
import IQAPIClient
import AuthenticationServices
import GoogleSignIn

@MainActor
final class SignUPViewModel: NSObject, ObservableObject {
    @Published var signUpData: SignUPModel?
    var errorMessage: String = ""
    @Published var shouldShowApiAlert: Bool = false
    @Published var token: String = ""
    @Published var isLoding: Bool = false
    @Published var isLodingUserName: Bool = false
    @Published var userNameAvailability: UserNameAvailabilityModel?
    @Published var showMessage: Bool = false
    var currentTimeZone: String {
            let timeZone = TimeZone.current
            let timeZoneName = timeZone.identifier
            return timeZoneName
        }
        
        var deviceType: String = StringConstants.Common.deviceType
        
        var deviceIdentifier: String {
            let device = KeychainManager.token ?? ""
            return device
        }

    func getUserName(userName: String, completion: @escaping (_ result: Swift.Result<UserNameAvailabilityModel, Error>) -> Void) {
        isLodingUserName = true
        IQAPIClient.userNameAvailability(userName: userName) { result in
            self.isLodingUserName = false
            switch result{
                
            case .success(let data):
                self.userNameAvailability = data
                self.showMessage = false
                if !data.isSucceed{
                    self.errorMessage = data.message
                    self.showMessage = true
                }
                completion(.success(data))
                break
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print(self.errorMessage)
                self.shouldShowApiAlert.toggle()
                completion(.failure(error))
                break
            }
        }
    }
    func doSignUP(name: String, email: String, userName: String, password: String, location: String, latitude: String, longitude: String, placeId: String, socialMediaAccountId: String,
                  SocialMediaPlatform: String, deviceType: String, deviceId: String, timeZone: String){
        isLoding = true
        IQAPIClient.signUP(name: name, email: email, userName: userName, password: password, location: location, latitude: latitude, longitude: longitude, placeId: placeId, socialMediaAccountId: socialMediaAccountId, SocialMediaPlatform: SocialMediaPlatform, deviceType: deviceType, deviceID: deviceId, timezone: timeZone){ result in
            self.isLoding = false
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
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
    }
}
extension SignUPViewModel: ASAuthorizationControllerDelegate {
    
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
            
            self.doSignUP(name: fullName, email: email ?? "" , userName: email ?? "", password: "", location: "", latitude: "", longitude: "", placeId: "", socialMediaAccountId: userid  , SocialMediaPlatform: StringConstants.Common.apple, deviceType: deviceType, deviceId: deviceIdentifier, timeZone: currentTimeZone)
        }
    }
}


