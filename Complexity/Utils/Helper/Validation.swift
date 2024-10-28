//
//  Validation.swift
//  Complexity
//
//  Created by IE Mac 05 on 10/05/24.
//

import Foundation
import Foundation

class RegistrationHelper {
    
    static let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        static let passwordRegex = #"(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}"#
        static let nameRegex = #"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"#
        
        static func validateEmail(_ email: String) -> Bool {
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
        
        static func validatePassword(_ password: String) -> Bool {
            let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
            return passwordPredicate.evaluate(with: password)
        }
        
        static func validateName(_ name: String) -> Bool {
            let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameRegex)
            return namePredicate.evaluate(with: name)
        }
        
        static func passwordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
            return password == confirmPassword
        }
}

extension String {
    func matches(regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }
}
