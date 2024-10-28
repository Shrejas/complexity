//
//  DrinkProfileView.swift
//  Complexity
//
//  Created by IE Mac 03 on 18/07/24.
//

import Foundation
import SwiftUI
import Kingfisher
import IQAPIClient

struct DrinkDetailProfileView: View {
    
    @State var drinkId: Int
    @State var postLikeCount: Int = 0
    @State var userRatingsCount: Int = 0
    @State var pageIndex: Int = 1
    @State var pageSize: Int = 10
    
    @State var isLoadingMore: Bool = true
    @State var isLoadMoreInProcess: Bool = false
    @State var isDrinkNameViewShow: Bool = false
   
    @State private var selectedPostIndex: Int = 0
    @State private var isShowDrinkDetail: Bool = false
    @StateObject private var drinkDetailProfileViewModel: DrinkDetailProfileViewModel = DrinkDetailProfileViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var isPlusButtonTapped: Bool = false
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            ScrollView {
                NavigationLink(isActive: $isDrinkNameViewShow) {
                    if let selectedDetailPost = drinkDetailProfileViewModel.selectedDetailPost {
                        DrinkNameView(post: selectedDetailPost)
                    }
                } label: {
                    EmptyView()
                }
                
                NavigationLink(isActive: $isShowDrinkDetail) {
                    if !drinkDetailProfileViewModel.relatedPost.isEmpty {
                        FeedDetailsView(post: $drinkDetailProfileViewModel.relatedPost[selectedPostIndex])
                    }
                } label: {
                    EmptyView()
                }
                if let drinkInfo = drinkDetailProfileViewModel.drinkInfo {
                    NavigationLink(
                        destination: NewPostView(drinkBrand: drinkInfo.brandName ?? "",categoryDrinkItem: drinkInfo.brandName ?? "", drinkName: drinkInfo.drinkName ?? ""),
                        isActive: $isPlusButtonTapped
                    ) {
                        EmptyView()
                    }
                }

                
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color._626465)
                                .frame(width: 34, height: 34)
                                .background(Color.white)
                                .onTapGesture {
                                    router.navigateBack()
                                }
                        }
                        .cornerRadius(17)
                        .padding(.leading, 25)
                        Spacer()
                        Text("Drink Profile")
                            .padding(.trailing, 50)
                        Spacer()
                        Text("")
                        
                    }
                    if drinkDetailProfileViewModel.isLoading {
                        DrinkProfileSkeltonView()
                    } else {
                        VStack {
                            ZStack {
                                if let drinkInfo = drinkDetailProfileViewModel.drinkInfo {
                                    VStack {
                                        if let imageUrl = drinkInfo.drinkImage {
                                            KFImage(URL(string: imageUrl))
                                                .resizable()
                                                .placeholder {
                                                    ProgressView()
                                                }
                                                .frame(height: 305)
                                                .frame(maxWidth: .infinity)
                                                .scaledToFit()
                                                .cornerRadius(16)
                                                .padding(.top, 15)
                                                .padding(.horizontal,25)
                                                .tag(1)
                                        }
                                        
                                        VStack(spacing: 0) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 0) {
                                                    if let brandName = drinkInfo.brandName, let drinkName = drinkInfo.drinkName {
                                                        Text(brandName)
                                                            .font(.muliFont(size: 13, weight: .semibold))
                                                            .foregroundColor(Color._626465)
                                                            .padding(.bottom, -5)
                                                        Text(drinkName)
                                                            .font(.muliFont(size: 20, weight: .bold))
                                                            .foregroundColor(Color._1D1A1A)
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .padding(.top, 10)
                                            
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text("You")
                                                        .font(.muliFont(size: 15, weight: .semibold))
                                                        .foregroundColor(Color._2A2C2E)
                                                    Text("Everyone")
                                                        .font(.muliFont(size: 15, weight: .semibold))
                                                        .foregroundColor(Color._2A2C2E)
                                                }
                                                Spacer()
                                                VStack(alignment: .trailing) {
                                                    VStack(alignment: .leading) {
                                                        if let overallAverageRating = drinkInfo.overallAverageRating, let userAverageRating = drinkInfo.userAverageRating, let overallRatingsCount = drinkInfo.overallRatingsCount, let userRatingsCount = drinkInfo.userRatingsCount {
                                                            HStack {
                                                                Text("\(userAverageRating)")
                                                                    .font(.muliFont(size: 13, weight: .regular))
                                                                HStack(spacing: 5) {
                                                                    ForEach(1...5, id: \.self) { index in
                                                                        if Double(index) <= Double(userAverageRating) {
                                                                            Image("starfill")
                                                                                .foregroundColor(.yellow)
                                                                                .frame(width: 12, height: 12)
                                                                        } else {
                                                                            Image("emptyStar")
                                                                                .foregroundColor(._E4E6E8)
                                                                                .frame(width: 12, height: 12)
                                                                        }
                                                                    }
                                                                }
                                                                Text("\(userRatingsCount)")
                                                                    .font(.muliFont(size: 13, weight: .regular))
                                                            }
                                                            
                                                            HStack {
                                                                Text(String(format: "%.1f", overallAverageRating))
                                                                    .font(.muliFont(size: 13, weight: .regular))
                                                                HStack(spacing: 5) {
                                                                    ForEach(1...5, id: \.self) { index in
                                                                        if Double(index) <= Double(overallAverageRating) {
                                                                            Image("starfill")
                                                                                .foregroundColor(.yellow)
                                                                                .frame(width: 12, height: 12)
                                                                        } else {
                                                                            Image("emptyStar")
                                                                                .foregroundColor(._E4E6E8)
                                                                                .frame(width: 12, height: 12)
                                                                        }
                                                                    }
                                                                }
                                                                Text("\(overallRatingsCount)")
                                                                    .font(.muliFont(size: 13, weight: .regular))
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                    
                                    .padding(.bottom,30)
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .center) {
                                            if let drinkCategory = drinkInfo.category, let drinkSubCategory = drinkInfo.subCategory {
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
                                            
                                            Spacer()
                                            Group {
                                                HStack(spacing: 3) {
                                                    Image("blueHeart")
                                                    
                                                    if let likeCount = drinkInfo.likesCount, likeCount != 0 {
                                                        Text("\(likeCount)")
                                                            .font(.muliFont(size: 12, weight: .semibold))
                                                            .foregroundColor(._626465)
                                                        
                                                        Text(likeCount < 2 ? "Like" : "Likes")
                                                            .font(.muliFont(size: 10, weight: .regular))
                                                            .foregroundColor(._626465)
                                                    }
                                                }
                                                .padding(.trailing, 25)
                                            }
                                        }
                                        .padding(.leading, 20)
                                        .padding(.top, -40)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .frame(height: 354, alignment: .topLeading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        .padding(.horizontal, 20)
                    }
                    
                    if !drinkDetailProfileViewModel.relatedPost.isEmpty {
                        HStack {
                            Text("Related Posts")
                                .font(.muliFont(size: 17, weight: .semibold))
                                .foregroundColor(Color._1D1A1A)
                            Spacer()
                            Button {
                                isDrinkNameViewShow.toggle()
                            } label: {
                                Text("See All")
                                    .font(.muliFont(size: 15, weight: .bold))
                                    .foregroundColor(Color._4F87CB)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    }
                    
                    VStack {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 20) {
                                ForEach(Array(drinkDetailProfileViewModel.relatedPost.enumerated()), id: \.element.postId) { index, post in
                                    PostFeedCellView(post: post, isFromDrinkDetailProfileView: true)
                                        .cornerRadius(20)
                                        .onTapGesture {
                                            selectedPostIndex = index
                                            isShowDrinkDetail = true
                                        }
                                        .frame(maxHeight: .infinity)
                                }
                            }
                        }
                        .frame(maxHeight: .infinity)
                        
                    }
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                    .background(Color._F4F6F8)
                }
                .background(Color._F4F6F8)
                .onAppear {
                    drinkDetailProfileViewModel.getDrinksData(drinkId: drinkId)
                }
                .alert(isPresented: $drinkDetailProfileViewModel.isShowAlert) {
                    Alert(title: Text("Error!"), message: Text(drinkDetailProfileViewModel.errrorMessage), dismissButton: .cancel() )
                }
                
            }
            .background(Color._F4F6F8)
            .navigationBarBackButtonHidden(true)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if let drinkInfo = drinkDetailProfileViewModel.drinkInfo {
                            router.navigate(to: .newPostViewWithDetail(brandName: drinkInfo.brandName ?? "", categoryDrinkItem: drinkInfo.brandName ?? "", drinkName: drinkInfo.drinkName ?? ""))
                        }
                    }, label: {
                        Image(ImageConstant.plusIcon)
                            .frame(width: 56,height: 56)
                    })
                    .padding(.trailing,25)
                }
                .padding(.bottom,90)
            }
        }

    }
}
