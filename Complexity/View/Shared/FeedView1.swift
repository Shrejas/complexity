//
//  FeedView1.swift
//  Complexity
//
//  Created by IE Mac 05 on 01/05/24.
//

import SwiftUI

struct FeedView1: View {
    @State private var isLikeClick = false
    @State private var rating = 5
    @State private var isImageTapped: Bool = false
    @State private var isFeedDetailViewShow: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var imageArray: [String] = ["imageFeed1", "imageFeed2", "imageFeed4"]
    @State private var comment = 3
    @State private var isLocationTapped:Bool = false

    var body: some View {
        VStack (alignment: .leading, spacing: 12){


            NavigationLink(isActive: $isLocationTapped) {
                LocationDetailsView()
            } label: {
                EmptyView()
            }


            NavigationLink(isActive: $isImageTapped) {
                FeedDetailsView(commentCounts: $comment)
            } label: {
                EmptyView()
            }
            NavigationLink(isActive: $isFeedDetailViewShow) {
                FeedDetailsView(commentCounts: $comment)
            } label: {
                EmptyView()
            }

            VStack (spacing: 0){
                HStack(alignment: .top) {
                    Image("faceImage")
                        .resizable()
                        .frame(width: 40,height: 40)
                        .cornerRadius(20)

                    HStack(alignment: .center, spacing: 5){

                        VStack (alignment: .leading, spacing: 4){
                            Text("Jersy Commpell")
                                .font(.muliFont(size: 15, weight: .bold))
                                .foregroundColor(Color._2A2C2E)
                                .frame( alignment: .topLeading)
                            HStack {
                                Image(ImageConstant.location)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16,height: 16)
                                Text("Social Club,Mumbai")
                                    .font(.muliFont(size: 12, weight: .regular))
                                    .foregroundColor(Color._8A8E91)
                            }.onTapGesture {
                                isLocationTapped.toggle()
                            }
                            HStack{
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16,height: 16)
                                    .foregroundColor(Color._8A8E91)
                                Text("13 hour ago")
                                    .font(.muliFont(size: 12, weight: .regular))
                                    .foregroundColor(Color._8A8E91)
                            }

                        } .frame(maxWidth: .infinity, alignment: .topLeading)

                        VStack(alignment: .center){
                            Menu {
                                Button(action: {
                                    showDeleteAlert.toggle()
                                }, label: {
                                    Text("Delete")
                                        .font(.muliFont(size: 12, weight: .regular))
                                })
                            }
                        label: {
                            Image(ImageConstant.dot)
                                .frame(width:30, height: 25)
                        }
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(title: Text("Delete"), message: Text("Are you sure you want to delete?"), primaryButton: .destructive(Text("Yes").foregroundColor(.red)) {

                            }, secondaryButton: .cancel())
                        }
                        .frame( alignment: .bottom)
                    }
                }
            }.padding(.top,-30)

            ZStack {

                //                Image("new Bottle")
                //                    .resizable()
                //                    .frame(height: 345)
                //                    .frame(maxWidth: .infinity)
                //                    .scaledToFit()
                //                    .cornerRadius(16)
                //                    .onTapGesture {
                //                        isImageTapped.toggle()
                //                    }

                TabView{
                    ForEach(imageArray.indices, id: \.self) { index in
                        Image(imageArray[index])
                            .resizable()
                            .frame(height: 345)
                            .frame(maxWidth: .infinity)
                            .scaledToFit()
                            .cornerRadius(16)
                            .onTapGesture {
                                isImageTapped.toggle()
                            }
                    }
                }.tabViewStyle(.page)
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
                    .padding(.leading, 10)
                    .padding(.top, 19)
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
                            .font(.muliFont(size: 15, weight: .semibold))
                            .foregroundColor(Color(._626465))
                        Spacer()
                    }

                    HStack{
                        Button(action: {

                        }, label: {
                            Image(ImageConstant.CommentIcon)
                        })
                        Text("234")
                            .font(.muliFont(size: 15, weight: .semibold))
                            .foregroundColor(Color(._626465))
                        Spacer()
                    }
                }
                .padding(.top,230)
                .padding(.leading,20)
            }

            VStack(alignment: .leading, spacing: 5){
                Text("New London Light")
                    .font(.muliFont(size: 13))
                    .foregroundColor(Color._626465)

                Text("Aegean Sky")
                    .font(.muliFont(size: 20, weight: .bold))
                    .foregroundColor(Color._1D1A1A)
                    .padding(.top, -10)

                HStack(alignment: .bottom){
                    Text("5.0")
                        .font(.muliFont(size: 15))
                        .foregroundColor(Color._2A2C2E)
                    StarRating(rating: $rating)
                    Text("(248)")
                        .font(.muliFont(size: 15))
                        .foregroundColor(Color._2A2C2E)
                }
                Button(action: {
                    isFeedDetailViewShow.toggle()
                }, label: {
                    Text("view all \(comment) comment")
                        .font(.muliFont(size: 13))
                        .foregroundColor(Color._626465)
                })
                HStack{
                    Text("Chritober Commpell")
                        .font(.muliFont(size: 13, weight: .bold))
                        .foregroundColor(Color._1D1A1A)

                    Text("Hello !")
                        .font(.muliFont(size: 13))
                        .foregroundColor(Color._626465)
                }
            }
        }
        .padding(14)
        .background(Color._F4F6F8)
        .cornerRadius(16)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    FeedView1()
}
