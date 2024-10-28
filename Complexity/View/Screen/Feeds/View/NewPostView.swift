////
////  NewPostView.swift
////  Complexity
////
////  Created by IE12 on 23/04/24.
////


import SwiftUI

struct NewPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @State public var drinkBrand = ""
    @State var drinkDetail: Drinks?
    @State private var addCaption = ""
    @State private var location = ""
    @State private var rating = 5
    @State var isCategoryTaped: Bool = false // openPlacePicker
    @State var isSubCategoryTaped: Bool = false
    @State var openPlacePicker: Bool = false
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    @State var searchTextField: String = ""
    @State private var selectedImage: UIImage?
    @State private var images: [UIImage] = []
    @State var imagesCount: Int?
    @State private var showImagePicker: Bool = false
    let maxImages = 5
    @State private var isShowingPhotoPicker = false
    
    @State var categoryDrinkItem = ""
    @State private var showAlert = false
    @State private var title = ""
    @State private var alertMessage = ""
    
    @State private var showingOptions = false
    @State private var selection = "None"
    @State private var showCamera = false
    
    @State private var isImageSelected: Bool = false
    // @State private var showAlert: Bool = false
    @State private var showHomeView: Bool = false
    @StateObject var viewModel: NewPostViewModel = NewPostViewModel()
    @State private var drinkCategory: String = ""
    @State private var drinkSubCategory: String = ""
    @State private var placeId: String = ""
    @State public var drinkName = ""
    @State private var rotationAngle: Angle = .zero
    @State private var selectedImages: [UIImage] = []
    @State public var isShowRotateView: Bool = false
    @State private var isDisableUI: Bool = false
    @EnvironmentObject var router: Router
    
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink(isActive: $isCategoryTaped) {
                    BrandDetail(brandName:$categoryDrinkItem)
                } label: {
                    EmptyView()
                }
                
                NavigationLink(isActive: $isSubCategoryTaped) {
                    DrinkDetail(drinkDetail: $drinkDetail, brandName: categoryDrinkItem)
                } label: {
                    EmptyView()
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(images.indices, id: \.self) { index in
                                    ZStack(alignment:.topTrailing) {
                                        Image(uiImage: images[index])
                                            .resizable()
                                            .frame(width: 90, height: 90)
                                            .scaledToFit()
                                            .background(Color.red)
                                            .cornerRadius(8)
                                        
                                        Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.red)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .padding([.top, .trailing], 2)
                                            .onTapGesture{
                                                if !isDisableUI {
                                                    images.remove(at: index)
                                                    imagesCount = images.count
                                                }
                                            }
                                    }.padding(5)
                                }
                                if images.count < 5 {
                                    
                                    HStack (alignment: .center) {
                                        Image(ImageConstant.uploadIc)
                                            .frame(width: 90, height: 90)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        if images.isEmpty {
                                            Text("Upload the Photos")
                                                .font(.muliFont(size: 17, weight: .semibold))
                                                .foregroundColor(Color._2A2C2E)
                                        }
                                    }
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .onTapGesture {
                                        if !isDisableUI {
                                            showingOptions = true
                                            imagesCount = images.count
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .topLeading)
                        .background(Color._F4F6F8)
                        .cornerRadius(20)
                    }
                    
                    VStack (alignment: .leading,spacing: 10) {
                        
                        SelectableTextField(title: "Drink Brand", placeholder: "Select Brand Name", text: $drinkBrand, imageSystemName: "chevron.forward",onTap: {
                            if !isDisableUI {
                                isCategoryTaped.toggle()
                            }
                        },hideTitle: false)
                    }
                    
                    VStack (alignment: .leading,spacing: 10) {
                        
                        SelectableTextField(title: "Drink Name", placeholder: "Drink Name", text: $drinkName, imageSystemName: "chevron.forward", onTap: {
                            if !isDisableUI {
                                if drinkBrand.isEmpty {
                                    showAlert = true
                                    alertMessage = "Please select brand name"
                                    title = "Error"
                                } else {
                                    isSubCategoryTaped.toggle()
                                }
                            }
                        })
                    }
                    VStack (alignment: .leading,spacing: 10) {
                        Text("Add Caption")
                            .font(.muliFont(size: 17, weight: .semibold))
                            .foregroundColor(Color._2A2C2E)
                        
                        TextField("Enter your caption", text: $addCaption,axis: .vertical)
                            .padding(EdgeInsets(top: -35, leading: 20, bottom: 10, trailing: 10))
                            .frame(height: 90)
                            .background(Color._F4F6F8)
                            .cornerRadius(20)
                            .disableAutocorrection(true)
                            .foregroundColor(Color._626465)
                            .font(.muliFont(size: 17, weight: .semibold))
                            .disabled(isDisableUI)
                        
                    }
                    VStack (alignment: .leading,spacing: 10) {
                        Text("Your Rating")
                            .font(.muliFont(size: 17, weight: .semibold))
                            .foregroundColor(Color._2A2C2E)
                        
                        HStack {
                            StarRating(rating: $rating)
                                .padding(.leading,5)
                                .padding(.leading,8)
                                .disabled(isDisableUI)
                            
                            Text("(\(rating) out of 5)")
                                .font(.muliFont(size: 12, weight: .regular))
                                .foregroundColor(Color._A0A0A0)
                        }
                        .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                        .background(Color._F4F6F8)
                        .cornerRadius(30)
                    }
                    
                    VStack (alignment: .leading,spacing: 10) {
                        
                        SelectableTextField(title: "Location", placeholder: "Location", text: $location, imageSystemName: "chevron.forward", onTap: {
                            if !isDisableUI {
                                openPlacePicker.toggle()
                            }
                        })
                    }
                    
                    Button(action: {
                        addNewPost()
                    }, label: {
                        HStack(alignment: .center, spacing: 8) {
                            HStack(alignment: .top, spacing: 2) {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Submit")
                                        .font(.muliFont(size: 17, weight: .bold))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 50)
                        .background(.blue)
                        .cornerRadius(30)
                    })
                    .disabled(isDisableUI)
                }.padding(20)
                    .frame(alignment: .topLeading)
                
                    .confirmationDialog("Select From", isPresented: $showingOptions, titleVisibility: .visible) {
                        Button("Camera") {
                            showCamera = true
                        }
                        
                        Button("Gallery") {
                            isShowingPhotoPicker.toggle()
                        }
                    }
                
                    .fullScreenCover(isPresented: $isShowingPhotoPicker, onDismiss: {
                        if !images.isEmpty {
                            isShowRotateView = true
                        }
                    }) {
                        PhotoPicker(selectedImages: $images, imagesCount: $imagesCount)
                            .ignoresSafeArea(.all)
                    }
            }
            .fullScreenCover(isPresented: $openPlacePicker) {
                PlacePicker(address: $location, openPlacePicker: $openPlacePicker, latitude: $latitude, longitude: $longitude, placeId: $placeId)
            }
            .fullScreenCover(isPresented: $isShowRotateView){
                RotateImageView(isShowRotateView: $isShowRotateView, images: $images)
            }
            .onChange(of: categoryDrinkItem) { newValue in
                drinkBrand = newValue
            }
            
            .onChange(of: drinkDetail) { newValue in
                drinkName = newValue?.drinkName ?? ""
                drinkCategory = newValue?.category ?? ""
                drinkSubCategory = newValue?.subCategory ?? ""
            }
        }
        .fullScreenCover(isPresented: $showCamera, onDismiss: {
            if !images.isEmpty {
                isShowRotateView = true
            }
        }) {
            CameraView(selectedImage: self.$images)
                .ignoresSafeArea(.all)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(title), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("New Post", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    router.navigateBack()
                } label: {
                    HStack {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(Color._626465)
                    }
                }
            }
            
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    hideKeyboard()
                }
                .foregroundColor(.blue)
            }
        }
        
    }
    
    private func addNewPost() {
        if validation() {
            isDisableUI = true
            viewModel.newPost(postId: 5, drinkName: drinkDetail?.drinkName ?? drinkName, drinkBrand: drinkBrand, drinkCategory: drinkCategory, drinkSubCategory: drinkSubCategory, caption: addCaption, rating: rating, location: location, latitude: "\(latitude)", longitude: "\(longitude)", placeId: placeId, image: images)  { result in
                
                isDisableUI = false
                
                switch result {
                case .success(let data):
                    if let isSucceed = viewModel.newPostData?.isSucceed, isSucceed {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .callRefreshMethod, object: nil)
                            router.navigateToRoot()
                            
                        }
                    } else {
                        title = "invalid"
                        alertMessage = viewModel.newPostData?.message ?? ""
                        showAlert = true
                    }
                    
                case .failure(let error):
                    title = "invalid"
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
    
    func validation() -> Bool {
        guard images.count > 0 else {
            showAlert = true
            alertMessage = "Please select image from gallery or camera"
            title = "Alert"
            return false
        }
        
        if drinkBrand.isEmpty {
            showAlert = true
            alertMessage = "Please select drink brand"
            title = "Alert"
            return false
        }
        
        if let drinkName = drinkDetail?.drinkName, drinkName.isEmpty {
            showAlert = true
            alertMessage = "Please select drink name"
            title = "Alert"
            return false
        }
        if addCaption.isEmpty {
            showAlert = true
            alertMessage = "Please enter caption"
            title = "Alert"
            return false
        }
        if location.isEmpty {
            showAlert = true
            alertMessage = "Please select location"
            title = "Alert"
            return false
        }
        
        return true
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


//#Preview {
//    NewPostView(categoryDrinkItem: "", drinkDetail: Drinks)
//}





import SwiftUI

struct SelectableTextField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var imageSystemName: String
    var onTap: () -> Void
    var hideTitle: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if !hideTitle {
                Text(title)
                    .font(.muliFont(size: 17, weight: .semibold))
                    .foregroundColor(Color._2A2C2E)
            }
            ZStack(alignment: .trailing) {
                TextField(placeholder, text: $text)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
                    .frame(height: 50)
                    .background(Color._F4F6F8)
                    .cornerRadius(100)
                    .foregroundColor(Color._626465)
                    .font(.muliFont(size: 15, weight: .semibold))
                    .disabled(true)
                
                Image(systemName: imageSystemName)
                    .resizable()
                    .frame(width: 6, height: 12)
                    .foregroundColor(Color._BCBBBB)
                    .padding(.trailing)
            }
            .onTapGesture {
                onTap()
            }
        }
    }
}
