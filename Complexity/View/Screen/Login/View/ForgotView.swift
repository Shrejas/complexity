//
//  ForgotView.swift
//  Complexity
//
//  Created by IE12 on 20/04/24.
//

import SwiftUI

struct ForgotView: View {
    @Environment(\.presentationMode) var presentationMode
    @State public var email = ""
    @State private var showAlert: Bool = false
    @StateObject private var viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel()
    @State private var isVerifyTapped: Bool = false
    @State private var title = ""
    @State private var alertMessage = ""
    @State private var isTrue: Bool = false
    //@Binding  var isVerifyTapped: Bool
    
    var body: some View {
        ZStack {
            
            VStack {
                NavigationLink(isActive: $isVerifyTapped) {
                    PasswordVerificationView(isEmail: $email)
                } label: {
                    EmptyView()
                }
                Text("Forgot Password")
                    .font(.muliFont(size: 34, weight: .bold))
                    .foregroundColor(Color._1D1A1A)
                
                
                Text("           Don’t worry! It happens sometime,\n  Enter your email and we’ll send you a an OTP")
                    .frame(alignment: .center)
                    .font(.muliFont(size: 15, weight: .regular))
                    .foregroundColor(Color._8A8E91)
                
                CustomTextField(placeholder: "Email", imageName: ImageConstant.email, text: $email, keyboardType: .emailAddress, isEditable: .constant(true))
                    .padding(.top, 31)
                    .padding(.horizontal,20)
                    .autocapitalization(.none)
                
                Button(action: {
                    sendButtonAction()
                }, label: {
                    
                    ZStack(alignment: .center) {
                        Text("Send")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color._4F87CB)
                            .foregroundColor(.white)
                            .cornerRadius(100)
                            .font(.muliFont(size: 17, weight: .bold))
                            .padding(.top,30)
                        
                    }
                })
                .padding(.horizontal,20)
                
                Spacer()
            }.padding(.top,30)
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { showAlert || viewModel.shouldShowApiAlert },
            set: { showAlert = $0; viewModel.shouldShowApiAlert = $0 }
        )){
            if showAlert {
                
                return Alert(title: Text(title), message: Text(alertMessage), dismissButton: .default(Text("Ok"), action: moveToPasswordVerificationView)
                )
            } else {
                return Alert(title: Text(title), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok"))
                )
            }
        }
        
        .navigationBarBackButtonHidden(true)
        //.navigationBarHidden(true)
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
    
    private func showAlert(title: String, message: String, isPresent: Bool) {
        self.title = title
        alertMessage = message
        isTrue = isPresent
        showAlert = true
    }
    
   
    private func moveToPasswordVerificationView() {
        self.isVerifyTapped = isTrue
    }
    
    private func sendButtonAction(){
            viewModel.forgotPassword(email: email) {
                if let isSucceed = viewModel.forgotPasswordData?.isSucceed{
                    if isSucceed{
                        showAlert(title: "Success", message: viewModel.forgotPasswordData?.message ?? "", isPresent: true)
                    } else {
                        showAlert(title: "Invalid", message: viewModel.forgotPasswordData?.message ?? "", isPresent: false)
                    }
                }
            }
    }
}
