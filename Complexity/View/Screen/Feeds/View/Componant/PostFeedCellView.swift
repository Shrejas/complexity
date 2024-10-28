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
    
    let post: FeedPost
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    @State var isFromDrinkDetailProfileView: Bool = false
    
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
            
            VStack(alignment: .leading, spacing: 5) {
                Text(post.drinkBrand)
                    .font(.muliFont(size: 12, weight: .semibold))
                    .foregroundColor(._626465)
                    
                Text(post.drinkName)
                    .font(.muliFont(size: 15, weight: .bold))
                    .foregroundColor(._1D1A1A)
                
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
                .padding(.bottom, 8)
                
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
            }
            .padding(.leading, 15)
            .padding(.top, 15)
            
            Spacer()
        }
        .onAppear {
//            rating = post.rating ?? 0
//            likeCount = post.likeCount
//            commentCount = post.commentCount
        }
        .frame(width: UIScreen.main.bounds.width - 34) //, height: 150)
//        .padding(10)
        .background(Color.white)
        .cornerRadius(20)
//        .background(
//            GeometryReader { geometry in
//                VStack {
//                    Spacer()
//                    Color.white
//                        .frame(height: 1)
//                        .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 1)
//                }
//                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
//            }
//        )
    }
    
}

