//
//  SignUpView.swift
//  Complexity
//
//  Created by IE12 on 19/04/24.
//

import SwiftUI
import GoogleSignIn
import AuthenticationServices

struct SignUpView: View {
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var location: String = ""
    @State private var isPasswordShow = true
    @State private var isSecure = true
    @State private var title = ""
    @State private var alertMessage = ""
    @State private var showHomeView = false
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: SignUPViewModel = SignUPViewModel()
    
    @State private var isLogout: Bool = false
    @State var openPlacePicker: Bool = false
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    @State var placeId: String = ""
    @State private var isButtonDisable: Bool = false
    @State private var showWebContentView: Bool = false
    @State private var webViewURL:URL?
    @State private var webViewTitle:String = ""
    
    var currentTimeZone: String {
            let timeZone = TimeZone.current
            let timeZoneName = timeZone.identifier
            return timeZoneName
        }
        
        var deviceType: String = StringConstants.Common.deviceType
        
        var deviceIdentifier: String {
            let device = KeychainManager.token ?? ""
            return device
        }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    
                    NavigationLink(isActive: $showHomeView) {
                        HomeView()
                    } label: {
                        EmptyView()
                    }
                    
                    NavigationLink(isActive: $showWebContentView) {
                        WebContentView(policyURL: webViewURL, title: webViewTitle)
                    } label: {
                        EmptyView()
                    }
                    
                    VStack(spacing:9) {
                        Text("Create An Account")
                            .font(.muliFont(size: 34, weight: .bold))
                            .padding(.top,25)
                        
                        Text("Create a free profile to explore products ")
                            .font(.muliFont(size: 14, weight: .regular))
                            .foregroundColor(Color._8A8E91)
                            .frame(alignment: .center)
                    }
                    VStack{
                        CustomTextField(placeholder: "Full Name", imageName: ImageConstant.useric, text: $fullName, keyboardType: .default, isEditable: .constant(true))
                            .padding(.top, 30)
                            .autocapitalization(.words)
                        
                        CustomTextField(placeholder: "Email", imageName: ImageConstant.email, text: $email, keyboardType: .emailAddress, isEditable: .constant(true))
                            .padding(.top, 10)
                            .autocapitalization(.none)
                        
                        CustomEmailTextFeild(placeholder: "Username", imageName: ImageConstant.useric, text: $userName, keyboardType: .default, isLoading: $viewModel.isLodingUserName){
                            // viewModel.getUserName(userName: userName)
                        }
                        .onChange(of: userName, perform: { newValue in
                            userName = newValue.lowercased()
                            userName = newValue.replacingOccurrences(of: " ", with: "")
                            if !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                viewModel.getUserName(userName: userName){result in
                                    switch result{
                                    case .success(let data):
                                        if data.isSucceed{
                                            isButtonDisable = false
                                        } else {
                                            isButtonDisable = true
                                        }
                                        
                                    case .failure(_):
                                        break
                                    }
                                }
                            }
                        })
                        
                        .padding(.top, 10)
                        .textContentType(.username)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
//                        .onChange(of: userName) { newValue in
//                            userName = newValue.lowercased()
//                            userName = newValue.replacingOccurrences(of: " ", with: "")
//                        }
                        
                        if viewModel.showMessage {
                            Text("* \(viewModel.errorMessage)")
                                .foregroundColor(.red)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color._F4F6F8)
                            
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 21)
                                if isPasswordShow {
                                    SecureField("Password", text: $password)
                                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 12))
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
                        
                        CustomTextField(placeholder: "Location", imageName: ImageConstant.location, text: $location, keyboardType: .default, isEditable: .constant(true))
                            .padding(.top, 15)
                            .onTapGesture{
                                openPlacePicker.toggle()
                            }
                            .fullScreenCover(isPresented: $openPlacePicker) {
                                PlacePicker(address: $location, openPlacePicker: $openPlacePicker, latitude: $latitude, longitude: $longitude, placeId: $placeId, filterType: .places)
                            }
                        VStack {
                            HStack {
                                Button(action: {
                                    isSecure.toggle()
                                }) {
                                    Image(isSecure ? ImageConstant.UnCheckIcon : ImageConstant.CheckedICon)
                                        .frame(width: 17,height: 17)
                                        .border(Color._E4E6E8, width: 1)
                                        .cornerRadius(5)
                                    
                                }
                                HStack(spacing:0){
                                    Text("I agree the ")
                                        .foregroundColor(Color(._626465))
                                        .font(.muliFont(size: 15, weight: .regular))
                                    Button(action: {
                                        webViewTitle = "Terms and Conditions"
                                        webViewURL = URL(string: APIPath.termsAndConditions.rawValue)
                                        showWebContentView.toggle()
                                    }) {
                                        Text("Terms and Conditions ")
                                            .foregroundColor(Color._2A2C2E)
                                            .font(.muliFont(size: 15, weight: .semibold))
                                        
                                    }
                                    Text("&")
                                        .foregroundColor(Color._2A2C2E)
                                        .font(.muliFont(size: 15, weight: .regular))
                                }
                                Spacer()
                            }
                            .padding(.leading,4)
                            HStack {
                                Button(action: {
                                    webViewTitle = "Privacy Policy"
                                    webViewURL = URL(string: APIPath.privacyPolicy.rawValue)
                                    showWebContentView.toggle()
                                }, label: {
                                    Text("Privacy Policy")
                                        .foregroundColor(Color._2A2C2E)
                                        .font(.muliFont(size: 15, weight: .semibold))
                                    
                                })
                                Spacer()
                            }
                            .padding(.leading, 30)
                            .padding(.top, -17)
                        }
                        .padding(.top,0)
                    }
                    .padding(.horizontal,20)
                    
                    Button(action: {
                        validateRegistrationData()

                    }, label: {
                        Text("Sign Up")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height:50)
                            .background(Color._4F87CB)
                            .foregroundColor(.white)
                            .cornerRadius(100)
                            .padding([.leading, .trailing])
                            .font(.muliFont(size: 17, weight: .bold))
                            .padding(.top,10)
                    })
                    .disabled(isButtonDisable)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(title), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
//                    Text("Or Sign In With")
//                        .foregroundColor(Color._8A8E91)
//                        .font(.muliFont(size: 15, weight: .regular))
//                        .padding(.top,20)
                    VStack(spacing:50){
//                        HStack (spacing:5){
//                            Spacer()
//                            Button(action: {
//                                viewModel.signInWithGoole()
//                            }) {
//                                Image("google")
//                                    .resizable()
//                                    .frame(width: 50, height: 50)
//                                    .aspectRatio(contentMode:.fill)
//                            }
//                            .cornerRadius(8)
//                            Button(action: {
//                                viewModel.performAppleSignIn()
//                                
//                            }) {
//                                Image("apple")
//                                    .resizable()
//                                    .frame(width: 50, height: 50)
//                            }
//                            .cornerRadius(8)
//                            Spacer()
//                        }
//                        .padding(.top,1)
                        VStack{
                            Spacer()
                            HStack(spacing:5){
                                Text("Already have an account?")
                                    .foregroundColor(Color._8A8E91)
                                    .font(.muliFont(size: 15, weight: .regular))
                                
                                Button(action: {

                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("Sign In")
                                        .foregroundColor(Color._2A2C2E)
                                        .font(.muliFont(size: 15, weight: .bold))
                                })
                            }
                        }
                        .padding(.top,-15)
                    }
                    Spacer()
                }
            }
            if viewModel.isLoding {
                ProgressView()
            }
        }
        .onChange(of: viewModel.signUpData?.isSucceed ?? false, perform: { value in
            showHomeView = value
        })
        .onChange(of: viewModel.shouldShowApiAlert, perform: { newValue in
            showAlert(title: "Invalid", message: viewModel.errorMessage)
        })
        
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            if isLogout{
                presentationMode.wrappedValue.dismiss()
            }
            
        }
        
//        .navigationDestination(isPresented: $showHomeView) {
//            HomeView()
//        }
    }
    private func showAlert(title: String, message: String) {
        
        self.title = title
        alertMessage = message
        showAlert = true
    }
}



extension SignUpView {
    
    private func validateRegistrationData() {
        
        guard !fullName.isEmpty else {
            showAlert(title: "Error", message: "Full name cannot be empty")
            return
        }
        guard RegistrationHelper.validateName(fullName) else {
            showAlert(title: "Error", message: "Invalid name")
            return
        }
        guard !email.isEmpty else {
            showAlert(title: "Error", message: "Email cannot be empty")
            return
        }
        guard RegistrationHelper.validateEmail(email) else {
            showAlert(title: "Error", message: "Invalid email")
            showAlert = true
            return
        }
        guard !userName.isEmpty else {
            showAlert(title: "Error", message: "Username cannot be empty")
            return
        }
        guard RegistrationHelper.validateName(userName) else {
            showAlert(title: "Error", message: "Invalid user name")
            return
        }
        guard !password.isEmpty else {
            showAlert(title: "Error", message: "Password cannot be empty")
            return
        }

        guard !location.isEmpty else {
            showAlert(title: "Error", message: "Location cannot be empty")
            return
        }
        guard RegistrationHelper.validateName(location) else {
            showAlert(title: "Error", message: "Invalid location")
            return
        }
        
        viewModel.doSignUP(name: fullName, email: email, userName: userName, password: password, location: location, latitude: "", longitude: "", placeId: "", socialMediaAccountId: "", SocialMediaPlatform: "", deviceType: deviceType, deviceId: deviceIdentifier, timeZone: currentTimeZone )
    }
}

#Preview {
    SignUpView()
}
