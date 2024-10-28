//
//  StarRattingView.swift
//  Complexity
//
//  Created by IE12 on 23/04/24.
//

import Foundation
import SwiftUI

struct StarRating: View {
    @Binding var rating: Int
    var label = ""
    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color._FBB03B

    func image(for index: Int) -> Image {
        if index >= rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }

    var body: some View {
        HStack(spacing:0){
            if !label.isEmpty {
                Text(label)
            }
            ForEach(1..<maximumRating + 1) { index in
                self.image(for: index)
                    .foregroundColor(index > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = index
                    }
            }
        }
    }
}


struct FractionalRatingView: View {

    @Binding var rating: Double

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                if Double(index) <= self.rating {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                } else if Double(index) - 0.5 == self.rating {
                    Image(systemName: "star.lefthalf.fill")
                        .foregroundColor(.yellow)
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                }
            }
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
