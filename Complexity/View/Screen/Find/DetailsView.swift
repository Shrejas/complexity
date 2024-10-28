//
//  DetailsView.swift
//  Complexity
//
//  Created by IE12 on 02/05/24.
//

import SwiftUI

struct DetailsView: View {

    @State private var rating = 5
    @State private var imageArray: [String] = ["imageFeed1", "imageFeed2", "imageFeed4"]

    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .gray
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }

    var body: some View {
        VStack{
            ZStack {
                TabView{
                    ForEach(imageArray.indices, id: \.self) { index in
                        Image(imageArray[index])
                            .resizable()
                            .frame(height: 305)
                            .frame(maxWidth: .infinity)
                            .scaledToFit()
                            .cornerRadius(16)
                            .padding(.horizontal,25)
                    }
                }
                .tabViewStyle(.page)
                .padding(.bottom,20)
            }
            .background(Color._F4F6F8)
            .frame(height: 350)
        }
        VStack{
            HStack{
                VStack{
                    Text("New London Light")
                        .font(.muliFont(size: 13, weight: .regular))
                    Text("Aegean Sky")
                        .font(.muliFont(size: 20, weight: .bold))
                }
                Spacer()
            }
            HStack{
                Text("5.0")
                StarRating(rating: $rating)
                Text("(248)")
                Spacer()
            }
        }
        .padding(.leading,30)
        VStack{
            HStack{
                HStack {
                    Image(ImageConstant.location)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16,height: 16)

                    Text("Social club,mumbai")
                        .font(.muliFont(size: 12, weight: .regular))
                }
                HStack{
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16,height: 16)
                        .foregroundColor(Color._8A8E91)
                    Text("13 hour ago")
                        .font(.muliFont(size: 12, weight: .regular))
                }
                Spacer()
            }
            .padding(.leading,30)
            HStack{
                Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy")
                    .font(.muliFont(size: 15, weight: .regular))
                    .foregroundColor(Color._8A8E91)
                Spacer()
            }
            .padding(.leading,30)
        }
    }
}

#Preview {
    DetailsView()
}
