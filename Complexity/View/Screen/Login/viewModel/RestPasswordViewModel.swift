//
//  VerificationPasswordViewModel.swift
//  Complexity
//
//  Created by IE12 on 09/05/24.
//

import Foundation
import IQAPIClient
@MainActor
final class ResetPasswordViewModel: ObservableObject {
    @Published var resetData: ForgotPasswordModel?

    var errorMessage: String = ""
    @Published var shouldShowApiAlert: Bool = false

//    func resetPassword(userName: String, otp: Int, newPassword: String) {
//        IQAPIClient.resetPassword(userName: userName, otp: otp, newPassword: newPassword) { result in
//            switch result {
//            case .success(let data):
//                self.resetData = data
//                print(self.resetData)
//
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//                self.shouldShowApiAlert.toggle()
//                print(self.errorMessage)
//            }
//        }
//    }
    func resetPassword(userName: String, otp: Int, newPassword: String, completion: @escaping (ForgotPasswordModel?) -> Void) {
        IQAPIClient.resetPassword(userName: userName, otp: otp, newPassword: newPassword) { result in
            switch result {
            case .success(let data):
                // Handle successful reset password response
                // Assuming resetData is of type ForgotPasswordModel
                self.resetData = data
                print(self.resetData)
                completion(data)

            case .failure(let error):
                // Handle error
                self.errorMessage = error.localizedDescription
                self.shouldShowApiAlert.toggle()
                print(self.errorMessage)
                completion(nil)
            }
        }
    }

}