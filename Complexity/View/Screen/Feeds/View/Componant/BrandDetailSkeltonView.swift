//
//  BrandDetailSkeltonView.swift
//  Complexity
//
//  Created by IE Mac 05 on 05/06/24.
//

import SwiftUI
import SkeletonUI

struct BrandDetailSkeltonView: View {
    @State var isSkeletonUIPresenting: Bool
   
    var body: some View {
        VStack {
            HStack{
                Rectangle()
                    .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 350, height: 40), animation: .pulse() , shape: .rectangle)
                    .cornerRadius(16)
            }
            
            ScrollView(showsIndicators: false) {
                ForEach(0 ..< 10){ number in
                    HStack(spacing: 20) {
                        ForEach(0 ..< 3) {_ in
                            Rectangle()
                                
                                .skeleton(with: isSkeletonUIPresenting, size: CGSize(width: 100, height: 100), animation: .pulse(), shape: .rectangle)
                                .cornerRadius(16)
                                
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BrandDetailSkeltonView(isSkeletonUIPresenting: true)
}
