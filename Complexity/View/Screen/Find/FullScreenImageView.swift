//
//  FullScreenImageView.swift
//  Complexity
//
//  Created by IE Mac 03 on 13/08/24.
//

import SwiftUI
import Kingfisher

struct FullScreenImageView: View {
    var imageURL: URL
    
    var body: some View {
        VStack {
            KFImage(imageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
        }
    }
}
