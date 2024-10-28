//
//  loginScreen.swift
//  Complexity
//
//  Created by IE12 on 19/04/24.
//

import SwiftUI
struct loginScreen: View {
    @State var emailText: String = ""
    @State var passwordtext: String = ""
   // @StateObject private var loginPage = LoginPageModel()
    @State var wrongEmail = 0
    @State var wrongPassword = 0
    @State var showingLoginScreen = false
    @State  var isCheck: Bool = false
    @State private var showForgotPasswordView = false
    @State private var showCreateAccountView = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isPasswordVisible = false

    var body: some View {
        NavigationView {
            
            ZStack{
                VStack(spacing: 70){
                    Text("Login")
                        .font(.largeTitle)
                        .bold()

                    VStack(spacing: 20){
                        TextField("Email", text: $emailText)
                            .padding()
                            .frame(width: 330,height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(wrongEmail))
                        ZStack(){
                            if isPasswordVisible {
                                TextField("Password", text: $passwordtext)
                                    .padding()
                                    .frame(width: 330, height: 50)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .border(.red, width: CGFloat(wrongPassword))
                                    .textContentType(.password)
                            } else {
                                SecureField("Password", text: $passwordtext)
                                    .padding()
                                    .frame(width: 330, height: 50)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .border(.red, width: CGFloat(wrongPassword))
                                    .textContentType(.password)
                            }
                            HStack(){
                                Spacer()
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                }
                            }
                            .padding(.trailing,50)
                        }
                        HStack {
                            Image(systemName: isCheck ? "checkmark.square.fill" : "square")
                                .onTapGesture {
                                    isCheck.toggle()
                                }
                            Text("Remember me")
                            Spacer()
                            NavigationLink (
                                destination: ForgotPassword(),
                                isActive: $showForgotPasswordView,
                                label: {
                                    Button("Forgot password") {
                                        showForgotPasswordView = true
                                    }
                                }
                            )
                        }
                        .padding(.leading, 32)
                        .padding(.trailing, 32)
                    }
                    NavigationLink (
                        destination: CreateAccount(),
                        isActive: $showCreateAccountView,
                        label: {
                            Button("Login"){
                                // Handle the login action
                                if emailText.isEmpty || !isValidEmail(email: emailText) {
                                    showAlert = true
                                    alertMessage = "Please enter a valid email address."
                                    return
                                }
                                if passwordtext.isEmpty || !isValidPassword(password: passwordtext){
                                    showAlert = true
                                    alertMessage = "Please enter a password."
                                    return
                                }
                                showCreateAccountView = true
                            }
                        }
                    )
                    .foregroundColor(.white)
                    .frame(width: 330,height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }

                    Spacer()
                    HStack(){
                        Text("Don't have an account?")
                        Button("Sign up"){
                        }
                    }
                    .padding(.bottom,20)
                }
                .padding(.top, 50)
            }
        }
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
struct loginScreen_Previews: PreviewProvider {
    static var previews: some View {
        loginScreen()
    }
}
