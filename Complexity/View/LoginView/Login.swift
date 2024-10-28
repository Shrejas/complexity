//
//  LoginView.swift
//  Complexity
//
//  Created by IE12 on 19/04/24.
//

import SwiftUI

struct Login: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure = true
    @State private var isPasswordShow = true
    @State private var showForgotView = false
    @State private var showCreateAccountView = false
    @State private var showAlert = false
    @State private var title = ""
    @State private var alertMessage = ""
    @State private var isForgotTapped: Bool = false
    
    var body: some View {
        VStack{
            NavigationLink(isActive: $isForgotTapped) {
                ForgotView()
            } label: {
                EmptyView()
            }
            
            NavigationLink(isActive: $showCreateAccountView) {
                SignUpView()
            } label: {
                EmptyView()
            }
            
            Text("Sign In")
                .font(.muliFont(size: 34, weight: .bold))
                .foregroundColor(Color._1D1A1A)
                .padding(.top, 21)
            
            Text("Access to your account")
                .font(.muliFont(size: 15, weight: .regular))
                .foregroundColor(Color._8A8E91)
            
            CustomTextField(placeholder: "Username", imageName: ImageConstant.useric, text: $email)
                .padding(.top,35)
            
            
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
                                .padding(.leading, 10)
                        }
                        else {
                            Image(isPasswordShow ? ImageConstant.passwordHide : ImageConstant.passwordVisible)
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                        }
                    })
                    
                    if isPasswordShow {
                        SecureField("Password", text: $password)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                            .frame(height: 50)
                            .foregroundColor(Color._2A2C2E)
                            .font(.muliFont(size: 15, weight: .regular))
                    } else {
                        TextField("Password", text: $password)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                            .frame(height: 50)
                            .foregroundColor(Color._2A2C2E)
                            .font(.muliFont(size: 15, weight: .regular))
                    }
                }
            }
            .padding(.top,20)
            .frame(height: 50)
            
            HStack{
                Button(action: {
                    isSecure.toggle()
                }, label: {
                    Image(isSecure ? ImageConstant.UnCheckIcon : ImageConstant.CheckedICon)
                        .frame(width: 17,height: 17)
                        .cornerRadius(5)
                        .border(Color._E4E6E8, width: 1)
                })
                Text("Remember me")
                    .foregroundColor(Color(._626465))
                    .font(.muliFont(size: 15, weight: .regular))
                Spacer()
                Button(action: {
                    isForgotTapped.toggle()
                }, label: {
                    Text("Forgot Password?")
                        .foregroundColor(Color(._626465))
                        .font(.muliFont(size: 15, weight: .regular))
                })
            }
            .padding(.top,20)
            .padding(.horizontal, 1)
            
            Button(action: {
                validation()
            }, label: {
                Text("Sign In")
                    .padding(.horizontal,20)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color._4F87CB)
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    .font(.muliFont(size: 17, weight: .bold))
                    .padding(.top,39)
                
            }).alert(isPresented: $showAlert) {
                Alert(title: Text(title), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Text("Or Sign In With")
                .foregroundColor(Color._8A8E91)
                .font(.muliFont(size: 15, weight: .regular))
                .padding(.top,31)
            
            HStack (spacing:5){
                Spacer()
                Button(action: {
                    
                }){
                    Image(ImageConstant.google)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .cornerRadius(8)
                
                Button(action: {
                    
                }) {
                    Image(ImageConstant.apple)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .cornerRadius(8)
                Spacer()
                
            }.padding(.top,17)
            Spacer()
            HStack(spacing:1){
                
                Text("Don't have an account?")
                    .foregroundColor(Color._8A8E91)
                    .font(.muliFont(size: 15, weight: .regular))
                NavigationLink(
                    destination: SignUpView(),
                    isActive: $showCreateAccountView,
                    label: {
                        Button(action: {
                            showCreateAccountView = true
                        }) {
                            Text("Sign Up")
                                .foregroundColor(Color._2A2C2E)
                                .font(.muliFont(size: 15, weight: .bold))
                        }
                    }
                )
            }.padding(.bottom,10)
        }
        .padding(.horizontal, 20)
    }
    //MARK: -function-
    func validation(){
        if email.isEmpty || !isValidEmail(email: email) {
            showAlert = true
            alertMessage = "Please enter your email address."
            title = "Email"
            return
        }
        if password.isEmpty || !isValidPassword(password: password) {
            showAlert = true
            alertMessage = "Please enter your password."
            title = "Password"
            return
        }
        showCreateAccountView = true
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}

#Preview {
    Login()
}
