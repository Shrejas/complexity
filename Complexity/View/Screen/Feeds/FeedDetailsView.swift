//
//  FeedDetailsView.swift
//  Complexity
//
//  Created by IE12 on 24/04/24.


import SwiftUI
import Kingfisher
import IQAPIClient

struct FeedDetailsView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var rating = 5
    @State private var commentText: String = ""
    @State private var isLocationTapped: Bool = false
    @State private var likeApiInProgress: Bool = false
    @State private var commentShow = false
    @State private var allComments: [Comment] = []

    @Binding var post: FeedPost
    @State private var selectedDetailPost: FeedPost?
    @State private var errorMessage: String? = nil
    @State private var showingAlert = false
    
    @State private var isPostLike: Bool = false
    @State private var likeCount: Int = 0

    init(post: Binding<FeedPost>) {
        _post = post
    }

    var body: some View {

        let _ = Self._printChanges()
        
        NavigationLink(isActive: $isLocationTapped) {
            if let selectedDetailPost = selectedDetailPost {
                LocationDetailsView(post: selectedDetailPost)
            }
        } label: {
            EmptyView()
        }
        
        let postDetail = post
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing:0){
                ZStack {
                    TabView {
                        if let imageUrl = postDetail.media {
                            ForEach(imageUrl.indices, id: \.self) { index in
                                KFImage(URL(string: imageUrl[index]))
                                    .resizable()
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .frame(height: 345)
                                    .frame(maxWidth: .infinity)
                                    .scaledToFit()
                                    .cornerRadius(16)
                                    
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .padding(.top,15)
                    VStack(alignment: .leading){
                        HStack(alignment: .center){
                            if let drinkCategory = post.drinkCategory, let drinkSubCategory = post.drinkSubCategory {
                                Group {
                                    HStack{
                                        Text(drinkCategory)
                                            .foregroundColor(Color._1D1A1A)
                                            .font(.muliFont(size: 13, weight: .regular))
                                    }

                                    HStack{
                                        Text(drinkSubCategory)
                                            .foregroundColor(Color._1D1A1A)
                                            .font(.muliFont(size: 13, weight: .regular))
                                    }
                                } .padding(.vertical,5)
                                    .padding(.horizontal, 10)
                                    .background(Color._E4E6E8)
                                    .cornerRadius(30)
                            }

                        }
                        .padding(.leading, 15)
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity,alignment: .leading)

                    }

                    .frame(height: 385, alignment: .topLeading)
                }
               // .background(Color._F4F6F8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal,30)
                VStack(alignment: .leading, spacing: 10){
                    HStack {
                        VStack(alignment: .leading, spacing: 0){
                            if let drinkBrand = postDetail.drinkBrand, let drinkName = postDetail.drinkName{
                                Text(drinkName)
                                    .font(.muliFont(size: 13, weight: .regular))

                                Text(drinkBrand)
                                    .font(.muliFont(size: 20, weight: .bold))
                                    .frame(alignment: .topLeading)
                            }
                        }
                        .padding(.top,6)
                        .frame(alignment: .leading)

                        Spacer()
//                        if !likeApiInProgress {
                            Button(action: {
                                likePost()
                                isPostLike.toggle()
                                if isPostLike {
                                    likeCount += 1
                                } else {
                                    likeCount -= 1
                                }
                            }, label: {
                                Image(isPostLike ? ImageConstant.likeFill : ImageConstant.LikeIcon)
                                
                            })
                            .frame(width: 34, height: 34)
                        if likeCount != 0 {
                            Text("\(likeCount)")
                                .font(.muliFont(size: 13, weight: .regular))
                                .foregroundColor(Color._626465)
                        }
                    }.frame(alignment: .topLeading)
                        .padding(.trailing, 40)

                    HStack(alignment: .center ,spacing: 3){
                        Text("\(rating).0")
                        StarRating(rating: $rating)
                            .disabled(true)
                        Spacer()
                    }
                }
                .padding(.leading,30)
                .onAppear{
                    if let rating = post.rating {
                        self.rating = rating
                    }
                    self.isPostLike = post.likedByMe
                    self.likeCount = post.likeCount
                }

                VStack{
                    VStack(spacing:15){
                        HStack(spacing:3){
                            Image(ImageConstant.location)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16,height: 16)

                            Text(postDetail.location ?? "")
                                .font(.muliFont(size: 15, weight: .regular))
                                .foregroundColor(Color._8A8E91)
                                .onTapGesture {
                                    selectedDetailPost = post
                                    isLocationTapped = true
                                }

                            Image(systemName: "calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16,height: 16)
                                .foregroundColor(Color._8A8E91)
                                .padding(.leading,12)
                            Text(postDetail.createdTime ?? "")
                                .font(.muliFont(size: 15, weight: .regular))
                                .foregroundColor(Color._8A8E91)
                            Spacer()
                        }
                        .padding(.leading,27)
                        HStack{
                            Text(postDetail.caption ?? "")
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
                        if postDetail.commentCount > 1{
                            Text("Comments")
                                .font(.muliFont(size: 17, weight: .bold))
                                .foregroundColor(Color._2A2C2E)
                        } else {
                            Text("Comment")
                                .font(.muliFont(size: 17, weight: .bold))
                                .foregroundColor(Color._2A2C2E)
                        }
                            Text("\(postDetail.commentCount)")
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

            let comments = allComments
            if allComments.count > 0  {
                
                ForEach(Array(allComments.enumerated()), id: \.element.postCommentId) { index, comment in
                    VStack{
                        HStack{
                            if let profilePicture = URL(string: comment.createByUserProfilePicture) {
                                KFImage(profilePicture)
                                    .resizable()
                                    .placeholder{
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .frame(width: 38,height: 38)
                                            .cornerRadius(19)
                                            .scaledToFit()
                                    }
                                    .frame(width: 38,height: 38)
                                    .cornerRadius(19)
                                    .padding(.top,15)
                            }

                            Text(comment.createdByUser)
                                .foregroundColor(Color._2A2C2E)
                                .font(.muliFont(size: 15, weight: .bold))

                            Text(comment.createdTime)
                                .foregroundColor(Color._8A8E91)
                                .font(.muliFont(size: 12, weight: .medium))

                            Spacer()
                            if comment.createdByUser == UserDefaultManger.getName() {
                                Menu {
                                    Button(action: {
                                        deleteComment(comment: comment)
                                        commentShow.toggle()
                                    }) {
                                        HStack {
                                            Image("delete")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                            Text("Delete")
                                                .font(.muliFont(size: 12, weight: .regular))
                                        }
                                        .frame(width: 50, height: 50)
                                    }
                                } label: {
                                    Image(ImageConstant.dot)
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
                        .padding(.trailing, 25)
                        .padding(.top,-17)
                        Spacer()
                    }
                }
            }
        }
        .refreshable {
            getAllComment()
        }
        .onAppear {
            getAllComment()
        }
        Spacer()
        VStack {
            HStack{
                if #available(iOS 16, *) {
                    TextField("Write your comment here ...", text: $commentText,axis: .vertical)
                        .font(.muliFont(size: 15, weight: .medium))
                        .foregroundColor(Color._8A8E91)
                        .padding(.leading ,10)
                } else {
                    TextField("Write your comment here ...", text: $commentText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.muliFont(size: 15, weight: .medium))
                        .foregroundColor(Color._8A8E91)
                        .padding(.leading ,10)
                }
                Spacer()
                Button(action: {
                    hideKeyboard()
                    addComment(comment: commentText)
                    commentText = ""
                }, label: {
                    Image(systemName: "paperplane.fill")
                })
                .foregroundColor(Color._8A8E91)
                .padding(.trailing,10)
            }
            .frame(height: 50)
            .background(.white)
            .cornerRadius(10)

            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color._E4E6E8, lineWidth: 1)
            )
            .padding(.horizontal,10)
            .padding()
        }
        .background(Color._F4F6F8)
        .padding(.leading,0)
        .navigationBarTitle(post.location ?? "", displayMode: .inline)

        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    commentText = ""
                    hideKeyboard()
                    presentationMode.wrappedValue.dismiss()

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
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Alert"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension View {
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension FeedDetailsView {

    private func likePost() {

        var postObject = post
        let previousLikeCount = postObject.likeCount
        let previousLikedByMe = postObject.likedByMe
        
        if postObject.likedByMe {
            postObject.likeCount -= 1
            postObject.likedByMe = false
        } else {
            postObject.likeCount += 1
            postObject.likedByMe = true
        }
        self.post = postObject
        self.likeApiInProgress =  true
        IQAPIClient.like(postId: postObject.postId) { httpUrlResponse, result  in
            self.likeApiInProgress =  false
            switch result {
            case .success(_):
                break
            case .failure(_):
                var revertedPostObject = self.post
                revertedPostObject.likeCount = previousLikeCount
                revertedPostObject.likedByMe = previousLikedByMe
                self.post = revertedPostObject
                
                break
            }
        }
    }

    private func getAllComment() {
        IQAPIClient.getAllComment(postId: post.postId) { httpUrlResponse, result  in
            switch result {
            case .success(let data):
                let comments = data.comment
                self.allComments = comments.reversed()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showingAlert.toggle()
            }
        }
    }

    private func addComment(comment: String) {

        guard comment.isEmpty == false else { return }

        post.commentCount += 1
        IQAPIClient.addComment(postId: post.postId, comment: comment) { httpUrlResponse, result  in

            switch result {
            case .success(let data):
                if let comment = data.comment {
                    self.allComments.insert(comment, at: 0)
                    self.addLatestComment(comment: comment)
                }
             case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showingAlert.toggle()
            }
        }
    }

    private func addLatestComment(comment: Comment) {
        self.post.recentComment = comment
    }

    private func deleteComment(comment: Comment) {
        let postCommentId = comment.postCommentId
        IQAPIClient.deleteComment(postCommentId: postCommentId) { httpUrlResponse, result  in
            switch result {
            case .success(let data):
                if data.isSucceed {
                    if let lastComment = self.allComments.last {
                        self.addLatestComment(comment: lastComment)
                    }
                    if let index = allComments.firstIndex(where: { $0.postCommentId == comment.postCommentId }) {
                            allComments.remove(at: index)
                            post.commentCount -= 1
                        }
                } else {
                    showingAlert = true
                    errorMessage = data.message
                }

                break

            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showingAlert.toggle()
            }
        }

        
    }
}



