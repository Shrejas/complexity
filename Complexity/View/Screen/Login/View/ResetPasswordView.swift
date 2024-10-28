//
//  ResetPasswordView.swift
//  Complexity
//
//  Created by IE12 on 01/05/24.
//

import SwiftUI

struct ResetPasswordView: View {

    @State private var password: String = ""
    @State private var verifyPassword: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var isPasswordShow = true
    @State private var isVerifyPasswordShow = true
    @State private var isPasswordChangedView:Bool = false
    @State private var showAlert: Bool = false
    @State private var title = ""
    @State private var alertMessage = ""
    @State private var isTrue: Bool = false
    @Binding var userName: String
    @State private var newPassword: String = ""
    @Binding var otp:String
    @StateObject private var viewModel: ResetPasswordViewModel = ResetPasswordViewModel()
    @State private var showAlertTwo = false

    var body: some View {
        VStack {
           
            NavigationLink(isActive: $isPasswordChangedView) {
                PasswordChangedView()
            } label: {
                EmptyView()
            }

            Text("Reset Password")
                .font(.muliFont(size: 34, weight: .bold))
                .foregroundColor(Color._1D1A1A)

            Text("Enter the new password. The password must \n             Contain at least 8 characters.")
                .frame(alignment: .center)
                .font(.muliFont(size: 15, weight: .regular))
                .foregroundColor(Color._8A8E91)
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color._F4F6F8)

                HStack {
                    Button(action: {
                        isPasswordShow.toggle()
                    }, label: {
                        if password.isEmpty{
                            Image(ImageConstant.passwordVisible)
                                .foregroundColor(.gray)
                                .padding(.leading, 17)
                        }
                        else {
                            Image(isPasswordShow ? ImageConstant.passwordHide: ImageConstant.passwordVisible)
                                .foregroundColor(.gray)
                                .padding(.leading, 17)
                        }
                    })

                    if isPasswordShow {
                        SecureField("New Password", text: $password)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                            .frame(height: 50)
                            .foregroundColor(Color._2A2C2E)
                            .font(.muliFont(size: 15, weight: .regular))
                    } else {
                        TextField("New Password", text: $password)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                            .frame(height: 50)
                            .foregroundColor(Color._2A2C2E)
                            .font(.muliFont(size: 15, weight: .regular))
                    }
                }
            }
            .padding(.top,52)
            .frame(height: 50)

            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color._F4F6F8)

                HStack {
                    Button(action: {
                        isVerifyPasswordShow.toggle()
                    }, label: {
                        if password.isEmpty{
                            Image(ImageConstant.passwordVisible)
                                .foregroundColor(.gray)
                                .padding(.leading, 17)
                        }
                        else {
                            Image(isVerifyPasswordShow ? ImageConstant.passwordHide: ImageConstant.passwordVisible)
                                .foregroundColor(.gray)
                                .padding(.leading, 17)
                        }
                    })

                    if isVerifyPasswordShow {
                        SecureField("Verify Password", text: $verifyPassword)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                            .frame(height: 50)
                            .foregroundColor(Color._2A2C2E)
                            .font(.muliFont(size: 15, weight: .regular))
                    } else {
                        TextField("Verify Password", text: $verifyPassword)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                            .frame(height: 50)
                            .foregroundColor(Color._2A2C2E)
                            .font(.muliFont(size: 15, weight: .regular))
                    }
                }
            }
            .padding(.top,65)
            .frame(height: 50)

            Button(action: {
                let isValid =  validation()
                if isValid {
                    viewModel.resetPassword(userName: userName, otp: Int(otp) ?? 0, newPassword: password, completion :{ result in
                        if let isSucceed = result?.isSucceed {
                            if isSucceed{
                                showAlert(title: "Success", message: result?.message ?? "", isPresent: true)
                            } else {
                                showAlert(title: "Invalid", message: result?.message ?? "", isPresent: false)
                            }
                        }
                    } )
                }
                
            }, label: {
                Text("Reset Password")
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color._4F87CB)
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    .font(.muliFont(size: 17, weight: .bold))
                    .padding(.top,30)

            })
            .padding(.top,40)
            .alert(isPresented: Binding<Bool> (
                get: { showAlert || viewModel.shouldShowApiAlert },
                set: { showAlert = $0; viewModel.shouldShowApiAlert = $0 }
                
            )) {
                if showAlert {
                    return Alert(title: Text(title), message: Text(alertMessage), dismissButton: .default(Text("Ok"), action: moveToPasswordVerificationView)
                    )
                } else {
                    return Alert(title: Text(title), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok"))
                    )
                }
            }
            Spacer()
        }
        .padding(.top,47)
        .padding(.horizontal,20)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isPasswordChangedView, destination: {
            PasswordChangedView()
        })
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
        //  .navigationBarHidden(true)
//        .navigationDestination(isPresented: $isPasswordChangedView) {
//            PasswordChangedView()
//        }
        
    }
    func validation() -> Bool{
        if password.isEmpty {
            verifyPassword = password
            showAlert = true
            alertMessage = "Please enter password"
            title = "Message"
            return false
        }
        if verifyPassword != password{
            showAlert = true
            alertMessage = "Please enter correct password"
            title = "Message"
            return false
        }

        return true
    }
    private func showAlert(title: String, message: String, isPresent: Bool) {
        self.title = title
        alertMessage = message
        isTrue = isPresent
        showAlert = true
    }
    
    
    private func moveToPasswordVerificationView() {
        self.isPasswordChangedView = isTrue
    }
}

//#Preview {
////    ResetPasswordView(otp: .constant("") )
//}



