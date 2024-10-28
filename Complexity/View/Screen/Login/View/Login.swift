//
//  LoginView.swift
//  Complexity
//
//  Created by IE12 on 19/04/24.
//

import SwiftUI
import FirebaseMessaging

struct Login: View {
    
#if targetEnvironment(simulator)
    
    @State private var email: String = "info.enum@gmail.com"
    @State private var password: String = "Info1010"
    #else
    
    @State private var email: String = ""
    @State private var password: String = ""
    #endif
    @State private var remberMeFlag = true
    @State private var isPasswordShow = true
//    @State private var showForgotView = false
    @State private var showCreateAccountView = false
    @State private var showHomeView = false
    @State private var showAlert = false
    @State private var title = ""
    @State private var alertMessage = ""
    @State private var isForgotTapped: Bool = false
    @State private var showLocationAlert = false
    @StateObject private var signUpViewModel: SignUPViewModel = SignUPViewModel()
    @StateObject private var viewModel: LoginViewModel = LoginViewModel()
    @StateObject private var userAuthModel = UserAuthModel()
    @State private var userName: String = ""
    @StateObject var locationManager = LocationDataManager()
    @State private var showProgressView = false
    @StateObject var notificationManager = NotificationManager()
     var timeZone: String {
         let timeZone = TimeZone.current
            let timeZoneName = timeZone.identifier
            return timeZoneName
        }
    
    var deviceType: String = StringConstants.Common.deviceType
    
    var deviceId: String {
        let deviceId = KeychainManager.token ?? ""
        return deviceId
    }
   
    var body: some View {
        //   ScrollView(.vertical, showsIndicators: false){
        ZStack {
            VStack{
                
                NavigationLink(isActive: $isForgotTapped) {
                    ForgotView()
                } label: {
                    EmptyView()
                }
                
                NavigationLink(isActive: $showHomeView) {
                    HomeView()
                } label: {
                    EmptyView()
                }
                
                Text("Sign In")
                    .font(.muliFont(size: 34, weight: .bold))
                    .foregroundColor(Color._1D1A1A)
                    .padding(.top, 47)
                
                Text("Access to your account")
                    .font(.muliFont(size: 15, weight: .regular))
                    .foregroundColor(Color._8A8E91)
                
                CustomTextField(placeholder: "Username or Email", imageName: ImageConstant.useric, text: $email, keyboardType: .emailAddress, isEditable: .constant(true))
                    .autocapitalization(.none)
                    .padding(.top,35)
                
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
                .padding(.top,20)
                .frame(height: 50)
                
                HStack{
                    Button(action: {
                        rememberMeButtonAction()
                    }, label: {
                        Image(remberMeFlag ? ImageConstant.CheckedICon : ImageConstant.UnCheckIcon)
                        
                            .frame(width: 17,height: 17)
                        //  .background(.red)
                            .border(Color._E4E6E8, width: 1)
                            .cornerRadius(5)
                        
                    })
                    Button(action: {
                        remberMeFlag.toggle()
                    }, label: {
                        Text("Remember me")
                            .foregroundColor(Color(._626465))
                            .font(.muliFont(size: 15, weight: .regular))
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        // validation()
                        isForgotTapped.toggle()
                        
                    }, label: {
                        Text("Forgot Password?")
                            .foregroundColor(Color(._626465))
                            .font(.muliFont(size: 15, weight: .regular))
                    })
                }
                .padding(.top,20)
                .padding(.horizontal, 1)
                
                
                VStack{
                    Button(action: {
                        validation()
                        
                    }, label: {
                        Text("Sign In")
                            .padding(.horizontal,20)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color._4F87CB)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .font(.muliFont(size: 17, weight: .bold))
                    })
                    
                } .padding(.top,39)
                
                Text("Or Sign In With")
                    .foregroundColor(Color._8A8E91)
                    .font(.muliFont(size: 15, weight: .regular))
                    .padding(.top,31)
                
                HStack (spacing:5){
                    Spacer()
                    Button(action: {
                        userAuthModel.loginWithGoogle()
                    }){
                        Image(ImageConstant.google)
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .cornerRadius(8)
                    
                    Button(action: {
                        userAuthModel.performAppleSignIn()
                    }) {
                        Image(ImageConstant.apple)
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .cornerRadius(8)
                    Spacer()
                }
                .padding(.top,17)
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
                }.padding(.bottom,5)
                    .alert(isPresented: $showLocationAlert) {
                        Alert(
                            title: Text("Location"),
                            message: Text("Please allow your location in setting"),
                            primaryButton: .default(Text("Allow"), action: {
                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsURL)
                                }
                            }),
                            secondaryButton: .default(Text("Don't Allow"), action: {
                            })
                        )
                    }
            }
            if viewModel.isLoading || userAuthModel.isLoading {
                ProgressView()
            }
        }

        .alert(isPresented: Binding<Bool>(
            get: {
                return viewModel.shouldShowApiAlert || showAlert
            },
            set: { newValue in
                if !newValue {
                    viewModel.shouldShowApiAlert = false
                    showAlert = false
                    userAuthModel.shouldShowApiAlert = false
                }
            })
        ) {
            if viewModel.shouldShowApiAlert {
                return Alert(
                    title: Text("Invalid"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK")) {
                    }
                )
            } else if showAlert {
                return Alert(
                    title: Text(title),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                    }
                )
            } else if userAuthModel.shouldShowApiAlert  {
                return Alert(
                    title: Text("Invalid"),
                    message: Text(userAuthModel.errorMessage),
                    dismissButton: .default(Text("OK")) {
                    }
                )
            } else {
                return Alert(title: Text(""), message: nil, dismissButton: nil)
            }
        }
        .onChange(of: viewModel.isSucced, perform: { value in
            showHomeView = true
        })
        
        .onChange(of: userAuthModel.isSucced, perform: { value in
            showHomeView = true
        })
        
        .onAppear {
            remberMeFlag = UserDefaultManger.getRememberMe() ?? false
            email = UserDefaultManger.getLoginEmail() ?? ""
            password = UserDefaultManger.getLoginPassword() ?? ""
            getCurrentLocation()
        }
        .padding(.horizontal, 20)
        .navigationBarHidden(true)
        .task {
            if let token = KeychainManager.token, token.isEmpty {
                Messaging.messaging().delegate = notificationManager
                UNUserNotificationCenter.current().delegate = notificationManager
                await notificationManager.request()
            }
        }
                
//        .navigationDestination(isPresented: $showCreateAccountView) {
//            SignUpView()
//        }
//        
//        .navigationDestination(isPresented: $isForgotTapped) {
//            ForgotView()
//        }
//        
//        .navigationDestination(isPresented: $showHomeView) {
//            HomeView()
//        }
    }
    
    private func rememberMeButtonAction() {
        remberMeFlag = !remberMeFlag
        UserDefaultManger.saveRememberMe(remberMeFlag)
        if remberMeFlag {
            UserDefaultManger.saveLoginEmail(email)
            UserDefaultManger.saveLoginPassword(password)
        } else {
            UserDefaults.standard.removeObject(forKey: StringConstants.UserDefault.loginEmail)
            UserDefaults.standard.removeObject(forKey: StringConstants.UserDefault.loginPassword)
        }
    }
    
    func validation() {
        guard !email.isEmpty else {
            showAlert = true
               alertMessage = "Email cannot be empty."
               title = "Email"
            return
        }
        
//        guard RegistrationHelper.validateEmail(email) else {
//            showAlert = true
//               alertMessage = "Please enter your email address."
//               title = "Email"
//            return
//        }
        
        guard !password.isEmpty else {
            showAlert = true
            alertMessage = "Password cannot be empty."
            title = "Password"
            return
        }
        
        viewModel.doLogin(userName: email, password: password, socialMediaPaltform: "", socialMediaAccountId: "", deviceType: deviceType, deviceId: deviceId, timezone: timeZone)
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

extension Login{
  private func getCurrentLocation(){
    locationManager.requestManger()
    DispatchQueue.main.async {
      switch locationManager.authorizationStatus {
      case .authorizedWhenInUse:
        print("Current location data is allowed.")
      case .restricted, .denied:
        print("Current location data was restricted or denied.")
        showLocationAlert.toggle()
      case .notDetermined:
        print("Finding your location...")
          locationManager.requestManger()
      default:
        print("Not determined")
      }
    }
  }
}

#Preview {
    Login()
}
