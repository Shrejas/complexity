//
//  NavigationLink.swift
//  Complexity
//
//  Created by IE Mac 05 on 14/05/24.
//

//import Foundation
//import SwiftUI
//struct NavigationLinks: View {
//    @Binding var isLocationTapped: Bool
//    @Binding var isImageTapped: Bool
//    @Binding var isFeedDetailViewShow: Bool
//    @Binding var isDrinkNameViewShow: Bool
//    @Binding var comment: Int
//    @EnvironmentObject var viewModel: FeedViewModel
//   // var post: FeedPost?
//    
//    var body: some View {
//        
//        NavigationLink(isActive: $isLocationTapped) {
//            LocationDetailsView()
//        } label: {
//            EmptyView()
//        }
//        NavigationLink(isActive: $isImageTapped) {
//            FeedDetailsView(commentCounts: $comment, post: viewModel.post, allComment: viewModel.allComment)
//                .environmentObject(viewModel)
//        } label: {
//            EmptyView()
//        }
//        NavigationLink(isActive: $isFeedDetailViewShow) {
//            FeedDetailsView(commentCounts: $comment, post: viewModel.post, allComment: viewModel.allComment)
//                .environmentObject(viewModel)
//        } label: {
//            EmptyView()
//        }
//        NavigationLink(isActive: $isDrinkNameViewShow) {
//            DrinkNameView()
//        } label: {
//            EmptyView()
//        }
//        
//    }
//}
