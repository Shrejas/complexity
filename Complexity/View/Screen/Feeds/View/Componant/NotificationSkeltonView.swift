//
//  NotificationSkeltonView.swift
//  Complexity
//
//  Created by IE Mac 05 on 11/06/24.
//

import SwiftUI
import SkeletonUI
struct NotificationSkeltonView: View {
    @State var isSkeletonUIPresenting:Bool
    var body: some View {
        HStack(spacing: 20) {
            Circle()
                .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 30, height: 30), animation: .pulse(), shape: .circle)
            VStack {
                HStack {
                    
                    Rectangle()
                        .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 150, height: 10), animation: .pulse(), shape: .rectangle)
                    
                    Rectangle()
                        .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 80, height: 10), animation: .pulse(), shape: .rectangle)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                }
                Rectangle()
                    .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 150, height: 10), animation: .pulse(), shape: .rectangle)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }.padding(16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

#Preview {
    NotificationSkeltonView(isSkeletonUIPresenting: true)
}
