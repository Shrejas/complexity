//
//  ProfileView.swift
//  Complexity
//
//  Created by IE12 on 23/04/24.
//

import SwiftUI
import HalfASheet
import Kingfisher


enum AlertType: Identifiable {
    case basicInfoAlert(String, String)
//    case logoutAlert
    case deleteProfile(String, String)
    case deleteAlert

    var id: Int {
        switch self {
        case .basicInfoAlert:
            return 0
//        case .logoutAlert:
//            return 1
        case .deleteProfile:
            return 2
        case .deleteAlert:
            return 3
        }
    }
}
struct ProfileView: View {
    @State private var isShowSaveButton: Bool = false
    @State private var userFullName: String = ""
    @State private var userEmail: String =  ""
    @State private var userName: String =  ""
    @State private var userPassword: String = ""
    @State private var userLocation: String =  ""
    @State var openPlacePicker: Bool = false
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    @State var placeId: String = ""
    @State private var isPasswordVisible = true
    @State private var showLogoutAlert: Bool = false
    @State private var changePasswordTapped: Bool = false
    @State private var showImagePicker = false
    @State private var image: UIImage?
    @Environment(\.dismiss) var dismiss
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var imagesCount: Int? = 4
    @State private var showAlert: AlertType?
    @State private var isLoading = false
    @State private var isbuttonDisable: Bool = false
    @State private var isLoadingImage = false
    @StateObject private var keyboard = KeyboardResponder()
    @StateObject private var signUpViewModel: SignUPViewModel = SignUPViewModel()
    @State private var showingAlert = false
    @State private var errorMessage: String? = nil


    var body: some View {

        NavigationLink(isActive: $changePasswordTapped) {
            ChangePasswordView()
        } label: {
            EmptyView()
        }

        ScrollView (showsIndicators: false){
            VStack {
                ZStack {
                    Button(action: {
                        showImagePicker.toggle()
                    }, label: {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 100, height: 100)
                                .cornerRadius(50)
                                .aspectRatio(contentMode: .fill)
                        } else if let imageUrl = UserDefaultManger.getProfilePicture() {
                                KFImage(URL(string: imageUrl))
                                .resizable()
                                .placeholder{
                                    ProgressView()
                                    .frame(width: 100, height: 100)
                                }
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(50)
                                .scaledToFit()
                            }
                        }
                    )
                    .disabled(!isShowSaveButton)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(selectedImage: $image)
                    }
                    if isShowSaveButton {
                        Button(action: {
                            showImagePicker.toggle()
                        }, label: {
                            Image(ImageConstant.editProfile)
                                .resizable()
                                .foregroundColor(Color.white)
                                .frame(width: 24,height: 24)
                                .padding(.top,88)
                                .cornerRadius(12)
                        })
                    }
                }
                .padding(.top,9)
                if let userName = UserDefaultManger.getName() {
                    let firstName = userName.components(separatedBy: " ").first ?? userName
                    Text(firstName)
                        .font(.muliFont(size: 20, weight: .bold))
                        .foregroundColor(Color._2A2C2E)
                }

                HStack {
                    Text("Basic Information")
                        .font(.muliFont(size: 22, weight: .bold))
                        .foregroundColor(Color._1D1A1A)
                    Spacer()
                        if isLoading {
                            ProgressView()
                        }
                }
                .padding(.horizontal, 20)
                .padding(.top, 37)

                VStack(spacing: 15) {
                    
                    CustomTextField(placeholder: "Name", imageName: ImageConstant.useric, text: $userFullName, keyboardType: .default, isEditable:  $isShowSaveButton)
                    
                    
                    CustomTextField(placeholder: "Email", imageName: ImageConstant.email, text: $userEmail, keyboardType: .emailAddress, isEditable:  .constant(false))
                        .autocapitalization(.none)
                    
                    
                    CustomTextField(placeholder: "UserName", imageName: ImageConstant.useric, text: $userName, keyboardType: .default, isEditable:  $isShowSaveButton)

                    
                    .textContentType(.username)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .onChange(of: userName) { newValue in
                        if isShowSaveButton && newValue != UserDefaultManger.getUserName() {
                            if !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                signUpViewModel.getUserName(userName: userName){result in
                                    switch result {
                                    case .success(let data):
                                        if data.isSucceed{
                                            isbuttonDisable = false
                                        } else {
                                            isbuttonDisable = true
                                        }
                                    case .failure(_):
                                        break
                                    }
                                }
                            }
                        } else {
                            signUpViewModel.showMessage = false
                        }
                    }

                    if signUpViewModel.showMessage {
                        Text("* \(signUpViewModel.errorMessage)")
                            .foregroundColor(.red)
                    }

                    if let location = UserDefaultManger.getLocation() {

                        CustomTextField(placeholder: "Location", imageName: ImageConstant.location, text: $userLocation, keyboardType: .default, isEditable: $isShowSaveButton)
                            .disabled(true)
                            .onTapGesture{
                                if isShowSaveButton {
                                    openPlacePicker.toggle()
                                }
                            }
                            .fullScreenCover(isPresented: $openPlacePicker) {
                                PlacePicker(address: $userLocation, openPlacePicker: $openPlacePicker, latitude: $latitude, longitude: $longitude, placeId: $placeId, filterType: .places)
                            }
                    }
                    VStack(spacing: 0) {
                        SelectableTextField(title: "", placeholder: "Change Password", text: .constant("Change Password"), imageSystemName: "chevron.forward", onTap: {
                            changePasswordTapped.toggle()
                        }, hideTitle: true)
                        .disabled(isLoading)
                    }
                    
                    DeleteButtonView(text:"Delete Account", buttonAction: {
                        showAlert = .deleteAlert
                    })
                    .opacity(isShowSaveButton ? 0.5 : 1.0)
                    .disabled(isShowSaveButton)

                    HStack(spacing: 10) {
                        
                        if isShowSaveButton {
                            Button {
                                withAnimation {
                                    isShowSaveButton.toggle()
                                }
                            } label: {
                                HStack {
                                    Text("Cancel")
                                        .foregroundColor(Color._4F87CB)
                                        .font(.muliFont(size: 15, weight: .regular))
                                        .frame(maxWidth: .infinity, minHeight: 50)
                                }
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color._4F87CB, lineWidth: 2)
                                )
                            }
                        }
                        
                        CustomButtonView(text: isShowSaveButton ? "Save" : "Edit", buttonAction: {
                            if isShowSaveButton {
                                saveButtonTapped()
                            } else {
                                withAnimation {
                                    isShowSaveButton.toggle()
                                }
                            }
                        })
                        .disabled(isbuttonDisable)
                        
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.bottom,80)
            .padding(.bottom, keyboard.currentHeight)
            .onAppear {
                getBasicInformation()
            }
            if isLoading{
               ProgressView()
            }
            
            VStack {
                
            }
        }

        .navigationBarBackButtonHidden(true)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading:
                                Button(action: {
            dismiss()
        }) {
            if !isShowSaveButton {
                Image(systemName: "arrow.backward")
                    .foregroundColor(Color._626465)
            }
        } .disabled(isShowSaveButton)
        )
        .alert(item: $showAlert) { alertType in
            switch alertType {
            case .basicInfoAlert(let title, let message):
                return Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))

            case .deleteProfile(let title, let message):
                return Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
            case .deleteAlert:
                return Alert(
                    title: Text("Confirm account"),
                    message: Text("Are you sure you want to delete acccount?"),
                    primaryButton: .destructive(Text("Yes"), action: {
                        deleteProfile()
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
        
    }
    

    private func deleteProfile() {

        IQAPIClient.deleteProfile() { httpUrlResponse, result  in
            isLoading = false
            switch result {
            case .success(let data):
                if data.isSucceed {
                    logoutButtonAction()
                } else {
                    showAlert = .basicInfoAlert("Error", data.message)
                }
                break
            case .failure(let error):
                showAlert = .basicInfoAlert("Error", error.localizedDescription)
            }
        }
    }

    private func getBasicInformation() {
        if let name = UserDefaultManger.getName() {
            self.userFullName = name
        }
        if let email = UserDefaultManger.getEmail() {
            self.userEmail = email
        }
        
        if let userName = UserDefaultManger.getUserName() {
            self.userName = userName
        }
        
        if let location = UserDefaultManger.getLocation() {
            self.userLocation = location
        }
    }
    
    
    private func saveButtonTapped() {
        
        let fullName = UserDefaultManger.getName() == userFullName ? "" : userFullName
        let email = UserDefaultManger.getEmail() == userEmail ? "" : userEmail
        let name = UserDefaultManger.getUserName() == userName ? "" : userName
        let location = UserDefaultManger.getLocation() == userLocation ? "" : userLocation
        let latitude = UserDefaultManger.getLatitude() == latitude ? "" : String(latitude)
        let longitude = UserDefaultManger.getLongitude() == longitude ? "" : String(longitude)
        let placeId = UserDefaultManger.getPlaceId() == placeId ? "" : placeId
        
        isLoading = true
        IQAPIClient.userUpdate(name: fullName, email: email, userName: name, password: "", location: location, latitude: latitude, longitude: String(longitude), placeId: placeId, socialMediaAccountId: "", socialMediaPlatform: "", profilePicture: image) { httpUrlResponse, result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    isShowSaveButton.toggle()
                    UserDefaultManger.saveName(data.userInfo?.name ?? "")
                    UserDefaultManger.saveUserId(data.userInfo?.userId ?? 0)
                    UserDefaultManger.saveUserName(data.userInfo?.userName ?? "")
                    UserDefaultManger.saveLocation(data.userInfo?.location ?? "")
                    UserDefaultManger.saveProfilePicture(data.userInfo?.profilePicture ?? "")
                    if let latitudeString = data.userInfo?.latitude, let latitude = Double(latitudeString) {
                        UserDefaultManger.saveLatitude(latitude)
                    }

                    if let longitudeString = data.userInfo?.longitude, let longitude = Double(longitudeString) {
                        UserDefaultManger.saveLongitude(longitude)
                    }
                    
                    showAlert = .basicInfoAlert("Success", data.message)

                case .failure(let error):
                    showAlert = .basicInfoAlert("Error", error.localizedDescription)
                }
            }
        }
    }
    
    private func logoutButtonAction(){
        GIDSignIn.sharedInstance.signOut()
        UserDefaultManger.clearAllData()
        NotificationCenter.default.post(name: .userLogoutNotification, object: nil)
        Messaging.messaging().deleteToken { error in
            if let error = error {
                print("Failed to delete FCM token:", error)
            } else {
                print("FCM token deleted successfully.")
                KeychainManager.token = nil
            }
        }
        appDelegate.setWindowGroup(AnyView(ContentView()))
    }
}


#Preview {
    ProfileView()
}


import SwiftUI
import Combine
import GoogleSignIn
import IQAPIClient
import FirebaseMessaging

final class KeyboardResponder: ObservableObject {
    private var cancellable: AnyCancellable?
    
    @Published private(set) var currentHeight: CGFloat = 0
    
    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { notification in
                guard let frame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
                    return nil
                }
                return frame.height
            }
            .sink { [weak self] height in
                self?.currentHeight = height
            }
    }
    
    deinit {
            cancellable?.cancel()
        }
}
