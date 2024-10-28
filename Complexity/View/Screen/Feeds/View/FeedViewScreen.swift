//
//  FeedViewScreen.swift
//  Complexity
//
//  Created by IE12 on 23/04/24.
//


import Foundation
import SwiftUI

struct FeedViewScreen: View {
    @State private var isPresentingModal = false
    @State private var isPlusButtonTapped: Bool = false
    @StateObject private var viewModel: FeedViewModel = FeedViewModel()
    
    var body: some View {
        
        ZStack {
            
            NavigationLink(isActive: $isPlusButtonTapped) {
                NewPostView()
            } label: {
                EmptyView()
            }
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing:7) {
                    ForEach(0..<5) { _ in
                        VStack{
                            FeedView()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal ,15)
                    }
                }.padding(.bottom, 130)
            }
            
            VStack{
                Spacer()
                HStack {
                    Text("")
                    Spacer()
                    Button(action: {
                        isPlusButtonTapped = true
                    }, label: {
                        Image(ImageConstant.plusIcon)
                    })
                    .padding(.trailing,10)
                }
                .padding(.bottom,70)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(Text("Feed"), displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                print("notification ")
            }){
                Image(ImageConstant.notificationIcon)
            }
            )
        }.onAppear{
            viewModel.getFeedData(pageIndex: 1, pageSize: 10)
        }
    }
}
struct FeedViewScreen_Previews: PreviewProvider {
    static var previews: some View {
        FeedViewScreen()
    }
}
