//
//  LoginView.swift
//  Complexity
//
//  Created by IE12 on 19/04/24.
//

import SwiftUI
struct LoginView: View {

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

        ScrollView {
              VStack {
                 NavigationLink(isActive: $isForgotTapped) {
                    ForgotView()
                 } label: {
                    EmptyView()
                 }

                  VStack(spacing:9){
                    Text("Sign In")
                        .font(.muliFont(size: 34, weight: .bold))
                        .foregroundColor(Color._1D1A1A)

                    Text("Access to your account")
                        .font(.muliFont(size: 15, weight: .regular))
                        .foregroundColor(Color._8A8E91)

                }.padding(.top,47)

                CustomTextField(placeholder: "Username", imageName: "user-ic", text: $email)

                    .padding(.top, 35)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)

                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color.F_4_F_6_F_8)
                    HStack {
                        Button(action: {
                            isPasswordShow.toggle()
                        }, label: {
                            Image(isPasswordShow ? "password-hide" : "password-visible")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
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
                .padding(.leading,20)
                .padding(.trailing,20)
                .frame(height: 50)

                HStack{
                    Button(action: {
                        isSecure.toggle()
                    }, label: {
                        Image(isSecure ? "UnCheckIcon" : "CheckedICon")
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

                } .padding(.top,20)
                  .padding(.leading,20)
                  .padding(.trailing,20)

                NavigationLink(
                    destination: SignUpView(),
                    isActive: $showCreateAccountView,
                    label: {
                        Button(action: {
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
                         }){
                            Text("Sign In")
                                //.padding([.leading, .trailing],20)
                                .padding(.horizontal,20)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color._4F87CB)
                                .foregroundColor(.white)
                                .cornerRadius(100)
                                .font(.muliFont(size: 17, weight: .bold))

                        }
                        .padding(.horizontal,20)
                    }
                ).alert(isPresented: $showAlert) {
                    Alert(title: Text(title), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .padding(.top,39)
                Text("Or Sign In With")
                    .foregroundColor(Color(._8_A_8_E_91))
                    .font(.muliFont(size: 15, weight: .regular))
                    .padding(.top,31)
                  VStack(spacing:0){
                      HStack (spacing:5){
                          Spacer()
                          Button(action: {

                          }){
                              Image("google")
                                  .resizable()
                                  .frame(width: 50, height: 50)
                          }
                          .cornerRadius(8)

                          Button(action: {

                          }) {
                              Image("apple")
                                  .resizable()
                                  .frame(width: 50, height: 50)
                          }
                          .cornerRadius(8)
                          Spacer()

                      }.padding(.top,15)
                      Spacer()
                      VStack {
                          Spacer()
                          HStack(spacing:1){

                              Text("Don't have an account?")
                                  .foregroundColor(Color(._8_A_8_E_91))
                                  .font(.muliFont(size: 15, weight: .regular))
                              NavigationLink(
                                destination: SignUpView(),
                                isActive: $showCreateAccountView,
                                label: {
                                    Button(action: {
                                        showCreateAccountView = true
                                    }) {
                                        Text("Sign Up")
                                            .foregroundColor(Color(._2_A_2_C_2_E))
                                            .font(.muliFont(size: 15, weight: .bold))
                                    }
                                }
                            )
                        }
                    }
                }
            }.padding(.top,5)
        }
        .navigationBarHidden(true)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

