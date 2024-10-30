//
//  PostFeedCellView.swift
//  Complexity
//
//  Created by IE Mac 03 on 18/07/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct PostFeedCellView: View {
    
    @State public var isShowAlert: Bool = false
    let post: FeedPost
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    @State var isFromDrinkDetailProfileView: Bool = false
    var onCellTap: (() -> Void)?
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? "read less" : " read more"
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                if let image = post.media?.first {
                    KFImage(URL(string: image))
                        .loadDiskFileSynchronously()
                        .resizable()
                        .placeholder{
                            ProgressView()
                        }
                        .frame(width: 120, height: 120)
                        .cornerRadius(10)
                }
            }
            .padding(.top, 15)
            .padding(.bottom, 5)
            .padding(.leading, 15)
            .onTapGesture {
                onCellTap?()
            }

            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 0) {
                    Text(post.drinkBrand)
                        .font(.muliFont(size: 12, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color.white)
                        .foregroundColor(._626465)
                        .onTapGesture {
                            onCellTap?()
                        }
                    
                    if let createdByUser = post.createdByUser {
                        if createdByUser == UserDefaultManger.getName() {
                            Menu {
                                Button(action: {
                                    NotificationCenter.default.post(name: .postDeleted, object: nil, userInfo: ["postId": post.id])
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                            .font(.muliFont(size: 12, weight: .regular))
                                    }
                                    .frame(width: 50, height: 50)
                                }
                            } label: {
                                Image(ImageConstant.dot)
                                    .frame(width: 30, height: 25)
                            }
                            
                        }
                    }
                }
                    
                Text(post.drinkName)
                    .font(.muliFont(size: 15, weight: .bold))
                    .foregroundColor(._1D1A1A)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .background(Color.white)
                    .onTapGesture {
                        onCellTap?()
                    }
                
                HStack(spacing: 3) {
                    Text("\(post.rating ?? 0)")
                        .font(.muliFont(size: 11, weight: .regular))
                    
                    HStack(spacing: 3) {
                        ForEach(1...5, id: \.self) { index in
                            if Double(index) <= Double(self.post.rating ?? 0) {
                                Image("starfill")
                                    .foregroundColor(.yellow)
                                    .frame(width: 12, height: 12)
                            } else {
                                Image("emptyStar")
                                    .foregroundColor(._E4E6E8)
                                    .frame(width: 12, height: 12)
                            }
                        }
                        Spacer()
                        
                        HStack(spacing: 1) {
                            Image("blueHeart")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 2)
                            if post.likeCount != 0 {
                                Text("\(post.likeCount)")
                                    .font(.muliFont(size: 11, weight: .semibold))
                                    .foregroundColor(Color._2A2C2E)
                                
                                Text(post.likeCount < 2 ? "Like" : "Likes")
                                    .font(.muliFont(size: 11, weight: .regular))
                                    .foregroundColor(Color._2A2C2E)
                                    .padding(.trailing, 5)
                            }
                        }
                    }
                    
                }
                .background(Color.white)
                .padding(.bottom, 8)
                .onTapGesture {
                    onCellTap?()
                }
                
                VStack(alignment: .leading) {
                    if let caption = post.caption {
                        Text(caption)
                            .font(.muliFont(size: 13, weight: .regular))
                            .foregroundColor(._626465)
                            .lineLimit( expanded ? nil : 2)
                            .background(
                                Text(caption).lineLimit(2)
                                    .font(.muliFont(size: 13, weight: .regular))
                                    .foregroundColor(._626465)
                                    .background(GeometryReader { visibleTextGeometry in
                                        ZStack { //large size zstack to contain any size of text
                                            Text(caption)
                                                .font(.muliFont(size: 13, weight: .regular))
                                                .foregroundColor(._626465)
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
                        if !isFromDrinkDetailProfileView {
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
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .onTapGesture {
                    onCellTap?()
                }
            }
            .padding(.leading, 15)
            .padding(.top, 15)
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 34)
        .background(Color.white)
        .cornerRadius(20)
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this post?"), primaryButton: .destructive(Text("Yes").foregroundColor(.red)) {
                
            }, secondaryButton: .cancel())
        }
    }
    
}

