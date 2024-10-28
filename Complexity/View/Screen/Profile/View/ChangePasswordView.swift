//
//  ChangePasswordView.swift
//  Complexity
//
//  Created by IE MacBook Pro 2014 on 21/05/24.
//

import Foundation
import SwiftUI
import IQAPIClient

struct ChangePasswordView: View {
    
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var alertTitleMessage: String = "Alert"
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ProfileViewModel = ProfileViewModel()
   
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Spacer()
                    Image(systemName: "lock.circle")
                        .resizable()
                        .foregroundColor(Color._4F87CB)
                        .frame(width: 100, height: 100)
                        .cornerRadius(50)
                        .aspectRatio(contentMode: .fill)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Change your password")
                        .font(.muliFont(size: 22, weight: .bold))
                        .foregroundColor(Color._1D1A1A)
                    Spacer()
                }
                
                SecurePasswordTextField(password: $oldPassword, placeholder: "Old Password")
                
                SecurePasswordTextField(password: $newPassword, placeholder: "Password ")
                
                SecurePasswordTextField(password: $confirmPassword, placeholder: "Confirm Password")
                
                Spacer()
                
                CustomButtonView(text: "Change Password", buttonAction: {
                    if validatePasswords() {
                        viewModel.updatePassword(oldPassword: oldPassword, newPassword: newPassword)
                    }
                })
            }
            .padding(.horizontal, 15)
            .padding(.top, 50)
            .padding(.bottom, 200)
            
        }
        .alert(isPresented: $showAlert, content: {
            Alert(
                title: Text(alertTitleMessage),
                message: Text(errorMessage),
                dismissButton: .default(Text("Ok"), action: {
                    if alertTitleMessage == "Success" {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            )
        })
        
        .onChange(of: viewModel.showAlert) { newValue in
                alertTitleMessage = viewModel.alertTitle
                errorMessage = viewModel.alertMassage
                showAlert = true
            
        }
       
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(Color._626465)
                    }
                }
            }
        }
    }
    
    private func updatePassword() {
        if validatePasswords() {
            IQAPIClient.updatePassword(currentPassword: oldPassword, newPassword: newPassword) { result in
                switch result {
                case .success(let data):
                    showAlert = true
                    if data.isSucceed {
                        alertTitleMessage = "Congrats"
                    } else {
                        alertTitleMessage = "Failed"
                    }
                    errorMessage = data.message
                case .failure(let error):
                    alertTitleMessage = "Failed"
                    errorMessage = error.localizedDescription
                    
                }
            }
        }
    }
    
    private func validatePasswords() -> Bool {
        
        let oldPass = oldPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        oldPassword = oldPass
        let newPass = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        newPassword = newPass
        let confirmPass = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        confirmPassword = confirmPass
        
        alertTitleMessage = "Alert"
        
        if oldPassword.isEmpty {
            errorMessage = "Old password cannot be empty."
            showAlert = true
            return false
        }
        
        if oldPassword.count < 8 {
            errorMessage = "Old password must be at least 8 characters long."
            showAlert = true
            return false
        }
        
        if newPassword.isEmpty {
            errorMessage = "New password cannot be empty."
            showAlert = true
            return false
        }
        
        if newPassword.count < 8 {
            errorMessage = "New password must be at least 8 characters long."
            showAlert = true
            return false
        }
        
        if confirmPassword.isEmpty {
            errorMessage = "Confirm password cannot be empty."
            showAlert = true
            return false
        }
        
        if confirmPassword.count < 8 {
            errorMessage = "Confirm password must be at least 8 characters long."
            showAlert = true
            return false
        }
        
        if newPassword != confirmPassword {
            errorMessage = "New password and confirmation password do not match."
            showAlert = true
            return false
        }

         return true
    }
}

struct SecurePasswordTextField: View {
    
    @State private var isPasswordShow: Bool = false
    @Binding var password: String
    let placeholder: String
    var onCommit: (() -> Void)?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color._F4F6F8)

            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                    .padding(.leading, 21)
                if isPasswordShow {
                    SecureField(placeholder, text: $password)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 12))
                        .frame(height: 50)
                        .foregroundColor(Color._2A2C2E)
                        .font(.muliFont(size: 15, weight: .regular))
                } else {
                    TextField(placeholder, text: $password, onEditingChanged: { isEditing in
                        if !isEditing {
                            onCommit?()
                        }
                    })
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                        .frame(height: 50)
                        .foregroundColor(Color._2A2C2E)
                        .font(.muliFont(size: 15, weight: .regular))
                }

                Button(action: {
                    isPasswordShow.toggle()
                }, label: {
                    Image(isPasswordShow ? ImageConstant.passwordHide : ImageConstant.passwordVisible)
                        .foregroundColor(.gray)
                        .padding(.leading, 17)
                })
                .padding(.trailing,15)
            }
        }
        .padding(.top,15)
        .frame(height: 50)
    }
}
