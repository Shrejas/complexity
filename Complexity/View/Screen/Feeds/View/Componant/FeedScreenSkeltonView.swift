//
//  FeedScreenSkeltonView.swift
//  Complexity
//
//  Created by IE Mac 05 on 28/05/24.
//

import SwiftUI
import SkeletonUI

struct FeedScreenSkeltonView: View {
    @State var isSkeletonUIPresenting: Bool
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                   Text("")
                        .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 50, height: 50), animation: .pulse(), shape: .circle)
                    
                    VStack(alignment: .leading) {
                        Text("")
                            .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 150, height: 15), animation: .pulse(), shape: .rectangle)
                            
                        HStack {

                            Text("")
                                .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 100, height: 15), animation: .pulse(), shape: .rectangle)
                            Text("")
                                .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 10, height: 15), animation: .pulse(), shape: .rectangle)
                            
                            
                        }
                    }
                    Spacer()
                    Text("")
                        .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 10, height: 30), animation: .pulse(), shape: .rectangle)
                    
                }
                .padding()
                
                // Product Image and Tags
                VStack(alignment: .leading) {
                   
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 300, height: 250), animation: .pulse(), shape: .rectangle)
                            .cornerRadius(16)
                            .padding()
                        HStack {
                            
                            Rectangle()
                                .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 50, height: 25), animation: .pulse(), shape: .rectangle)
                                .cornerRadius(16)
                            Rectangle()
                                .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 50, height: 25), animation: .pulse(), shape: .rectangle)
                                .cornerRadius(16)
                        }
                        .padding(.top, 25)
                        .padding(.leading, 20)
                        
                        
                    }
                    HStack {
                        Rectangle()
                            .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 100, height: 15), animation: .pulse(), shape: .rectangle)
                            .cornerRadius(8)
                        Spacer()
                        Rectangle()
                            .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 30, height: 30), animation: .pulse(), shape: .rectangle)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Product Details
                    VStack(alignment: .leading) {
                        Rectangle()
                            .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 100, height: 15), animation: .pulse(), shape: .rectangle)
                            .cornerRadius(8)
                            
                        Rectangle()
                            .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 100, height: 20), animation: .pulse(), shape: .rectangle)
                            .cornerRadius(8)
                        HStack {
                            ForEach(0..<5) { _ in
                                Circle()
                                    .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 30, height: 30), animation: .pulse(), shape: .circle)
                            }
                            Rectangle()
                                .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 50, height: 20), animation: .pulse(), shape: .rectangle)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                
            }
            .background(Color(UIColor.systemGroupedBackground))
            .cornerRadius(16)
            
        }.padding(10)
    }
}

#Preview {
    FeedScreenSkeltonView(isSkeletonUIPresenting: true)
}
