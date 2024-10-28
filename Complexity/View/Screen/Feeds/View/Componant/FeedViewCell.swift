//
//  FeedView1.swift
//  Complexity
//
//  Created by IE Mac 05 on 01/05/24.
//

import SwiftUI
import Kingfisher
import IQAPIClient
import PartialSheet

struct FeedViewCell: View {
    
    @State private var expanded: Bool = false
    @State private var isLocationTapped: Bool = false
    @State private var isExpanded: Bool = false
    @State private var truncated: Bool = false
    @State private var rating = 5
    @State private var comment = 3
    let isLocationNameClickable: Bool
    let isDrinkNameClickable: Bool

   
    @Binding var posts: [FeedPost]
    @Binding var post: FeedPost
    @Binding var isPostDeleted: Bool
    @Binding var selectedPostIdForShowLikes: Int
    @Binding var showLikesSheet: Bool
    @State private var isShowProfileView: Bool = false
    @State private var isShowPostProfile: Bool = false
    @State private var selectedProfileImage: String?
    @State private var selectedProfileName: String?
    @State private var userInfo: UserInfo?
    
    let onLocationTap: (FeedPost) -> Void
    let onDrinkNameTap: (FeedPost) -> Void
    let onDrinkImageTap: (FeedPost) -> Void
    
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? "read less" : " read more"
        }
    }
    
    var body: some View {
        
        LazyVStack(alignment: .leading, spacing: 12) {
            UserInfoView(isPostDeleted: $isPostDeleted ,postDetail: post,
                         isLocationNameClickable: isLocationNameClickable)
            {
                onLocationTap(post)
            }
            
            MediaCarouselView(post: post) {
                onDrinkImageTap(post)
            }
            
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    DrinkInfoView(post: post,
                                  isDrinkNameClickable: isDrinkNameClickable)
                    {
                        onDrinkNameTap(post)
                    }
                    
                    Spacer()
                    LikeButton(post: $post, selectedPostIdForShowLikes: $selectedPostIdForShowLikes, showLikesSheet: $showLikesSheet)
                        .onAppear {
                            selectedPostIdForShowLikes = post.postId
                        }
                    
                }
                .padding(.top, -8)
                .padding(.trailing, 10)
                
                if let rating = post.rating {
                    HStack(spacing: 2) {
                        Text("\(rating)")
                            .font(.muliFont(size: 15))
                            .foregroundColor(Color._2A2C2E)
                        StarRating(rating: .constant(rating))
                            .disabled(true)
                    }
                }
                
                VStack(alignment: .leading) {
                    if let caption = post.caption {
                        Text(caption)
                            .font(.muliFont(size: 15, weight: .regular))
                            .foregroundColor(Color._8A8E91)
                            .lineLimit( expanded ? nil : 2)
                            .background(
                                Text(caption).lineLimit(2)
                                    .font(.muliFont(size: 15, weight: .regular))
                                    .foregroundColor(Color._8A8E91)
                                    .background(GeometryReader { visibleTextGeometry in
                                        ZStack { 
                                            Text(caption)
                                                .font(.muliFont(size: 15, weight: .regular))
                                                .foregroundColor(Color._8A8E91)
                                                .background(GeometryReader { fullTextGeometry in
                                                    Color.clear.onAppear {
                                                        if fullTextGeometry.size.height == visibleTextGeometry.size.height{
                                                            self.truncated = false
                                                        } else {
                                                            self.truncated = fullTextGeometry.size.height > visibleTextGeometry.size.height
                                                        }
                                                    }
                                                })
                                        }
                                        .frame(height: .greatestFiniteMagnitude)
                                    })
                                    .hidden()
                            )
                        if truncated {
                            Button(action: {
                                withAnimation {
                                    expanded.toggle()
                                }
                            }, label: {
                                Text(moreLessText)
                                    .font(.muliFont(size: 15, weight: .regular))
                                    .foregroundColor(Color.blue)
                            })
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if let recentComment = post.recentComment {
                    RecentCommentView(recentComment: recentComment){
                        onDrinkImageTap(post)
                    }
                }
            }
        }
        .onAppear {
            if let rting = post.rating {
                rating = rting
            }
        }
        .onChange(of: isShowProfileView, perform: { value in
            if value {
                isShowPostProfile = true
            }
        })
        .padding(14)
        .background(Color._F4F6F8)
        .cornerRadius(16)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct MediaCarouselView: View {
    
    @State private var tabSelectedIndex = 0
    @State private var isBackArrowHidden: Bool = true
    @State private var isForwordArrowHidden: Bool = true
    
    let post: FeedPost
    let onImageTap: () -> Void
    
    var body: some View {
        ZStack {
            if let mediaList = post.media {
                VStack {
                    TabView(selection: $tabSelectedIndex) {
                        ForEach(Array(mediaList.enumerated()), id: \.offset) { index, media in
                            KFImage(URL(string: media))
                                .loadDiskFileSynchronously()
                                .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 200, height: 345)))
                                .resizable()
                                .placeholder {
                                    ProgressView()
                                }
                                .frame(height: 345)
                                .scaledToFit()
                                .cornerRadius(16)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                }
                .onTapGesture {
                    onImageTap()
                }
                
                HStack {
                    
                    Button(action: {
                        backArrowClicked()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 6.0, height: 10.0)
                            
                        }
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.white.opacity(0.5))
                        .clipShape(Circle())
                    }
                    .opacity(isBackArrowHidden ? 0 : 1)
                    
                    Spacer()
                    
                    Button(action: {
                        forwordArrowClicked()
                    }) {
                        HStack {
                            Image(systemName: "chevron.right")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 6.0, height: 10.0)
                        }
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.white.opacity(0.5))
                        .clipShape(Circle())
                    }
                    .opacity(isForwordArrowHidden ? 0 : 1)
                }
            }
            
            if let drinkCategory = post.drinkCategory, let drinkSubCategory = post.drinkSubCategory {
                VStack(alignment: .leading) {
                    HStack {
                        DrinkCategoryView(text: drinkCategory)
                        DrinkCategoryView(text: drinkSubCategory)
                    }
                    .padding(.leading, 10)
                    .padding(.top, 19)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 354, alignment: .topLeading)
            }
            
         
        }
        .onChange(of: tabSelectedIndex, perform: { newValue in
            print(newValue)
            if newValue == 0 {
                isForwordArrowHidden = false
                isBackArrowHidden = true
            } else if newValue > 0 {
                if let mediaListCount = post.media?.count {
                    if newValue < (mediaListCount - 1) {
                        isForwordArrowHidden = false
                        isBackArrowHidden = false
                    } else if newValue == (mediaListCount - 1) {
                        isForwordArrowHidden = true
                        isBackArrowHidden = false
                    }
                }
            }
        })
        
        .onAppear {
            updateArrows()
        }
    }

    private func updateArrows() {
        if let mediaList = post.media, mediaList.count > 0 {

            let mediaListCount = mediaList.count
            if mediaListCount == 1 {
                isBackArrowHidden = true
                isForwordArrowHidden = true
            } else if tabSelectedIndex == (mediaListCount - 1) {
                isBackArrowHidden = false
                isForwordArrowHidden = true
            } else if tabSelectedIndex == 0 {
                isBackArrowHidden = true
                isForwordArrowHidden = false
            } else {
                isBackArrowHidden = false
                isForwordArrowHidden = false
            }
        } else {
            isBackArrowHidden = true
            isForwordArrowHidden = true
        }
    }

    private func forwordArrowClicked() {
        withAnimation {
            tabSelectedIndex += 1
            updateArrows()
        }
    }
    private func backArrowClicked() {
        withAnimation {
            tabSelectedIndex -= 1
            updateArrows()
        }
    }
}

struct DrinkCategoryView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(Color._1D1A1A)
            .font(.muliFont(size: 13, weight: .regular))
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color._E4E6E8)
            .cornerRadius(30)
    }
}

struct DrinkInfoView: View {
    let post: FeedPost
    let isDrinkNameClickable: Bool
    let onDrinkNameTap: () -> Void
    
    var body: some View {
        if let drinkBrand = post.drinkBrand, let drinkName = post.drinkName {
            VStack(alignment: .leading) {
                Text(drinkBrand)
                    .font(.muliFont(size: 13))
                    .foregroundColor(Color._626465)
                Button {
                    if isDrinkNameClickable {
                        onDrinkNameTap()
                    }
                } label: {
                    Text(drinkName)
                        .font(.muliFont(size: 20, weight: .bold))
                        .foregroundColor(Color._1D1A1A)
                        .padding(.top, -10)
                }
            }
        }
    }
}

struct LikeButton: View {
    @Binding var post: FeedPost
    @Binding var selectedPostIdForShowLikes: Int
    @Binding var showLikesSheet: Bool
    @State var isApiCallingInProgress: Bool = false
    
    var body: some View {
        let likeCount = post.likeCount
        let likedByMe = post.likedByMe
        VStack(spacing: 5) {
            Button(action: {
                likePost(postId: post.postId)
                
            }) {
                Image(likedByMe ? ImageConstant.likeFill : ImageConstant.LikeIcon)
            }
            if likeCount != 0 {
                Button {
                    selectedPostIdForShowLikes = post.postId
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        showLikesSheet.toggle()
                    })
                    
                } label: {
                    let like = likeCount < 2 ? " Like" : " Likes"
                    Text("\(likeCount)" + like)
                        .font(.muliFont(size: 13, weight: .regular))
                        .foregroundColor(Color._626465)
                }
            }
            
        }
    }
    
    private func likePost(postId: Int) {
        if post.likedByMe {
            post.likeCount -= 1
            post.likedByMe = false
        } else {
            post.likeCount += 1
            post.likedByMe = true
        }
        
        isApiCallingInProgress = true
        IQAPIClient.like(postId: postId) { httpUrlResponse, result  in
            self.isApiCallingInProgress = false
        }
    }
}

struct RecentCommentView: View {
    let recentComment: Comment
    let onTap: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("view all comments")
                .font(.muliFont(size: 13))
                .foregroundColor(Color._626465)
                .padding(.top, 4)
                .onTapGesture {
                    onTap()
                }
            
            HStack(alignment: .top) {
                if let profilePictureURL = URL(string: recentComment.createByUserProfilePicture) {
                    KFImage(profilePictureURL)
                        .resizable()
                        .placeholder {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .cornerRadius(10)
                                .scaledToFit()
                        }
                        .frame(width: 20, height: 20)
                        .cornerRadius(10)
                        .scaledToFit()
                }
                Text(recentComment.createdByUser)
                    .font(.muliFont(size: 13, weight: .bold))
                    .foregroundColor(Color._1D1A1A)
            }
            Text(recentComment.comment)
                .font(.muliFont(size: 13))
                .foregroundColor(Color._626465)
                .lineLimit(2)
        }
        .padding(.top, -4)
    }
}
