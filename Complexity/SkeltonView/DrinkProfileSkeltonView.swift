//
//  DrinkProfileSkeltonView.swift
//  Complexity
//
//  Created by IE Mac 05 on 30/07/24.
//

import SwiftUI
import SkeletonUI

import SwiftUI
import SkeletonUI

struct DrinkProfileSkeltonView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 30) {
                Text("")
                 .skeleton(with: true, size: CGSize(width: 53, height: 21), animation: .pulse(), shape: .rectangle)
                Text("")
                .skeleton(with: true, size: CGSize(width: 80, height: 21), animation: .pulse(), shape: .rectangle)
                Spacer()
                Text("")
                .skeleton(with: true, size: CGSize(width: 25, height: 25), animation: .pulse(), shape: .circle)
            }
            Image("")
                .skeleton(with: true, size: CGSize(width: UIScreen.main.bounds.width - 65, height: 300), animation: .pulse(), shape: .rounded(.radius(8, style:.circular)))
            VStack(alignment: .leading, spacing: 10) {
                Text("")
                 .skeleton(with: true, size: CGSize(width: 53, height: 15), animation: .pulse(), shape: .rectangle)
                Text("")
                .skeleton(with: true, size: CGSize(width: 100, height: 21), animation: .pulse(), shape: .rectangle)
                HStack {
                    Text("")
                        .skeleton(with: true, size: CGSize(width: 53, height: 15), animation: .pulse(), shape: .rectangle)
                    Spacer()
                    Text("")
                        .skeleton(with: true, size: CGSize(width: 100, height: 15), animation: .pulse(), shape: .rectangle)
                }
                HStack {
                    Text("")
                        .skeleton(with: true, size: CGSize(width: 100, height: 15), animation: .pulse(), shape: .rectangle)
                    Spacer()
                    Text("")
                        .skeleton(with: true, size: CGSize(width: 100, height: 15), animation: .pulse(), shape: .rectangle)
                }
                
            }
            

        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .frame(width: UIScreen.main.bounds.width - 32, height: 482, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(16)
        
    }
}

#Preview {
    DrinkProfileSkeltonView()
}
