//
//  FeedDetailsView.swift
//  Complexity
//
//  Created by IE12 on 24/04/24.
//



struct UserInfo:Hashable{
    var imageName:String
    var userName:String
    var comment:String
}

import SwiftUI

struct FeedDetailsView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var isLikeClick = false
    @State private var rating = 5
    @State private var commentText: String = ""
    @State private var commentHere: String = "sdfas"
    @State private var imageName: String = ""
    @State private var userComments: [String] = []
    @State private var commentInput: String = ""

    @State private var commentCount:Int = 03
    @Binding var commentCounts:Int

    @State private var showingOptions = false
    @State private var commentShow = false

    @State private var imageArray: [String] = ["https://www.dryatlas.com/wp-content/uploads/2022/08/Seir-Hill-Mashville.jpg", "https://www.dryatlas.com/wp-content/uploads/2023/07/New-London-Light-First-Light.jpg", "https://www.dryatlas.com/wp-content/uploads/2022/08/Lyre_s-White-Cane-Spirit.jpg"]

    @State var commentsArray = [
        UserInfo(imageName: "faceImage", userName: "Chritober Commpell", comment: "Hello !"),
        UserInfo(imageName: "faceImage", userName: "Chritober Commpell", comment: "Hello !"),
        UserInfo(imageName: "faceImage", userName: "Chritober Commpell", comment: "Hello !")
    ]


    init(commentCounts: Binding<Int>) {
        _commentCounts = commentCounts
        UIPageControl.appearance().currentPageIndicatorTintColor = .gray
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)

        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
          UINavigationBar.appearance().standardAppearance = appearance
          UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
    
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    ZStack {
                        TabView {
                            ForEach(imageArray.indices, id: \.self) { index in
                                AsyncImage(url: URL(string: imageArray[index])) { image in
                                    image
                                        .resizable()
                                        .frame(height: 305)
                                        .frame(maxWidth: .infinity)
                                        .scaledToFit()
                                        .cornerRadius(16)
                                        .padding(.horizontal,25)
                                } placeholder: {
                                    ProgressView()
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())

                        .padding(.bottom,30)
                        VStack(alignment: .leading){
                            HStack {
                                HStack(alignment: .center){
                                    Button(action: {

                                    }, label: {
                                        Text("Sprite")
                                            .font(.muliFont(size: 13, weight: .regular))
                                            .foregroundColor(Color._1D1A1A)
                                            .frame(width: 53,height: 19)
                                            .padding([.vertical, .horizontal],1)

                                    })
                                }
                                .background(Color._E4E6E8)
                                .cornerRadius(30)
                                HStack(alignment: .center){
                                    Button(action: {
                                        // button ACTION
                                    }, label: {
                                        Text("Gin")
                                            .foregroundColor(Color._1D1A1A)
                                            .padding([.vertical, .horizontal],1)
                                    })
                                    .font(.muliFont(size: 13, weight: .regular))
                                    .foregroundColor(.black)
                                    .padding(2)
                                    .frame(width: 43,height: 23)
                                }
                                .background(Color._E4E6E8)
                                .cornerRadius(30)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                            }
                            .padding(.leading, 40)
                            .padding(.top, 21)
                            Spacer()
                        }
                        .frame(height: 354)
                        VStack {
                            HStack{
                                Button(action: {
                                    isLikeClick.toggle()
                                }, label: {
                                    if isLikeClick{
                                        Image(ImageConstant.likeFill)
                                    }else{
                                        Image(ImageConstant.LikeIcon)
                                    }
                                })
                                Text("147")
                                    .font(.muliFont(size: 15, weight: .regular))
                                    .foregroundColor(Color(._626465))
                                Spacer()
                            }

                            HStack{
                                Button(action: {

                                }, label: {
                                    Image(ImageConstant.CommentIcon)
                                })
                                Text("234")
                                    .font(.muliFont(size: 15, weight: .regular))
                                    .foregroundColor(Color(._626465))
                                Spacer()
                            }
                        }
                        .padding(.top,170)
                        .padding(.leading,40)
                    }
                    .background(Color._F4F6F8)
                    .frame(maxWidth: .infinity, alignment: .leading)


                    VStack(alignment: .leading, spacing: 10){

                        VStack(spacing: -3){
                            Text("New London Light")
                                .font(.muliFont(size: 13, weight: .regular))

                            Text("Aegean Sky")
                                .font(.muliFont(size: 20, weight: .bold))

                        }.padding(.top,6)
                        //     Spacer()

                        HStack(alignment: .center ,spacing: 3){
                            Text("5.0")
                            StarRating(rating: $rating)
                            Spacer()
                        }
                    }
                    .padding(.leading,30)
                    VStack{
                        VStack(spacing:15){
                            HStack(spacing:3){
                                Image(ImageConstant.location)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16,height: 16)

                                Text("Social Club, Mumbai")
                                    .font(.muliFont(size: 12, weight: .regular))
                                    .foregroundColor(Color._2A2C2E)

                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16,height: 16)
                                    .foregroundColor(Color._8A8E91)
                                    .padding(.leading,12)
                                Text("13 hour ago")
                                    .font(.muliFont(size: 12, weight: .regular))
                                    .foregroundColor(Color._2A2C2E)
                                Spacer()
                            }
                            .padding(.leading,27)
                            HStack{
                                Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy")
                                    .font(.muliFont(size: 15, weight: .regular))
                                    .foregroundColor(Color._8A8E91)
                                    .padding(.bottom,15)
                                Spacer()
                            }
                            .padding(.leading,30)
                        }
                        VStack{
                            Color.gray.frame(height: 1 / UIScreen.main.scale)
                        }

                        HStack(alignment: .center){
                            Text("Comments")
                                .font(.muliFont(size: 17, weight: .bold))
                                .foregroundColor(Color._2A2C2E)
                            Text("(0\(String(commentCount)))")
                                .font(.muliFont(size: 17, weight: .bold))
                                .foregroundColor(Color._2A2C2E)
                            Spacer()
                        }
                        .padding(.leading,30)
                        VStack{
                            Color.gray.frame(height: 1 / UIScreen.main.scale)
                        }
                    }
                }

                ForEach(commentsArray, id: \.self) { comment in
                    VStack{
                        HStack{
                            Image(comment.imageName)
                                .resizable()
                                .frame(width: 38,height: 38)
                                .cornerRadius(19)
                                .padding(.top,15)

                            Text(comment.userName)
                                .foregroundColor(Color._2A2C2E)
                                .font(.muliFont(size: 15, weight: .bold))

                            Text("2w ago")
                                .foregroundColor(Color._8A8E91)
                                .font(.muliFont(size: 15, weight: .bold))

                            Spacer()
                            Button(action: {
                                commentShow.toggle()
                            }, label: {
                                Image(ImageConstant.dot)
                            })
                            .sheet(isPresented: $commentShow) {

                            }
                            .confirmationDialog("Select From", isPresented: $commentShow, titleVisibility: .visible) {
                                Button("Delete comment") {

                                }

                                Button("Report comment") {

                                }
                            }
                        }
                        .padding(.leading,20)
                        HStack {
                            Text(comment.comment)
                                .foregroundColor(Color._8A8E91)
                                .font(.muliFont(size: 15, weight: .bold))
                                .padding(.top,-10)
                            Spacer()
                        }
                        .padding(.leading,70)
                        .padding(.top,-17)
                        Spacer()
                    }
                }
            }
            Spacer()
            VStack {
                HStack{
                    TextField("Write your comment here ...", text: $commentText)
                        .font(.muliFont(size: 17, weight: .semibold))
                        .foregroundColor(Color._8A8E91)
                        .padding(.leading ,30)
                    Spacer()
                    Button(action: {
                        print("clickeble")
                        let newItem = UserInfo(imageName: "faceImage", userName: "Chritober Commpell", comment: commentText)
                        commentsArray.append(newItem)
                        commentCount = commentCount + 1

                        if !commentText.isEmpty{
                            commentText = ""
                        }
                    }, label: {
                        Image(systemName: "paperplane.fill")
                    })
                    .foregroundColor(Color._8A8E91)
                    .padding(.trailing,30)
                }
                .frame(width:350, height: 50)
                .background(.white)
                .cornerRadius(10)
                .border(Color._E4E6E8, width: 1)
                .padding()
            }
            .background(Color._F4F6F8)
            .padding(.leading,0)
            .shadow(color: Color.black.opacity(0.10), radius: 6, x: 0, y: -5)
         
            .navigationBarTitle("Feed", displayMode: .inline)
      
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        commentCounts = commentCount
                        presentationMode.wrappedValue.dismiss()

                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color._626465)

                        }
                    }
                }
            }
      //  }
    }
}

#Preview {
    FeedDetailsView(commentCounts: .constant(03))
}

extension View {

    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }

}

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor?

    init(backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        if let backgroundColor = backgroundColor {
            appearance.backgroundColor = backgroundColor
        }
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    func body(content: Content) -> some View {
        content
    }
}
