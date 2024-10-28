//
//  PlaceDetailView.swift
//  Complexity
//
//  Created by IE Mac 05 on 11/06/24.
//

import SwiftUI

struct PlaceDetailView: View {
     var posts: [FeedPost]
    
     var post: FeedPost
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if let mediaList = post.media {
                            ForEach(Array(mediaList.prefix(5).enumerated()), id: \.offset) { index, media in
                                if let imageURL = URL(string: media) {
                                    RestorantAndBarView(imgaeURL: imageURL)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
            
            Text(post.createdByUser ?? "")
                .font(.muliFont(size: 17, weight: .bold))
                .foregroundColor(Color("2A2C2E"))
            
            Text(post.drinkName ?? "")
                .font(.muliFont(size: 15, weight: .regular))
                .foregroundColor(Color("8A8E91"))
        }
    }
}


