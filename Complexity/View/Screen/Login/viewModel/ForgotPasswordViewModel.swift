//
//  ForgotPasswordViewModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 07/05/24.
//

import Foundation
import IQAPIClient

@MainActor
final class ForgotPasswordViewModel: ObservableObject{
    @Published var forgotPasswordData: ForgotPasswordModel?
    var errorMessage: String = ""
    @Published var shouldShowApiAlert: Bool = false
    @Published var isLoading:Bool = false
    
    func forgotPassword(email: String, completion: @escaping () -> Void) {
        isLoading = true
        IQAPIClient.forgotPassword(userName: email) { result in
            self.isLoading = false
            switch result {
            case .success(let data):
                self.forgotPasswordData = data
                completion()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                
                self.shouldShowApiAlert.toggle()
                completion()
            }
        }
    }

}
