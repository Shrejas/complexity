//
//  ForgotPassword.swift
//  LoginPage SwiftUI
//
//  Created by IE13 on 26/12/23.
//

import SwiftUI

struct ForgotPassword: View {
    @StateObject  var forgotPassword =  ForgotPasswordModel()
    var body: some View {
        VStack(){
            Text("Forgot Password")
                .font(.largeTitle)
                .bold()
            TextField("Enter Email", text: $forgotPassword.passwordForgot)
                .padding()
                .frame(width: 330,height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
            Button("Reset Password") {
                           // Perform the action when the "Reset Password" button is tapped
                           resetPassword()
                       }
                       .foregroundColor(.white)
                       .frame(width: 330, height: 50)
                       .background(Color.blue)
                       .cornerRadius(10)

            Spacer()
        }
        .padding(.top, 50)
    }
    func resetPassword() {
            // Implement the logic to reset the password here
            // You can use the content of `forgotPassword.passwordForgot` for the email input
            // Add your password reset logic here
        }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword()
    }
}
