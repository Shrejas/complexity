//
//  FindNearByItemCell.swift
//  Complexity
//
//  Created by IE Mac 03 on 13/08/24.
//

import SwiftUI
import GoogleMaps
import GooglePlaces
import Kingfisher

struct FindNearByItemCell: View {
    
    var imgaeURL:[URL]
    @State var  isFullScreen: Bool = false
    @State var  isFullScreen1: Bool = false
    @State var  isFullScreen2: Bool = false
//    @State var selectedImage: URL
    var body: some View {
        HStack{
            KFImage(imgaeURL.first)
                .loadDiskFileSynchronously()
                .resizable()
                .placeholder{
                    ProgressView()
                        .frame(width: 150, height: 200)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 200)
                .cornerRadius(10)
                .onTapGesture {
                    isFullScreen = true
                }
                .sheet(isPresented: $isFullScreen) {
                    FullScreenImageView(imageURL: imgaeURL.first ?? URL(fileURLWithPath: ""))
                        .onDisappear{
                            isFullScreen = false
                        }
                }
            VStack{
                if imgaeURL.count >= 2 {
                    KFImage(imgaeURL[1])
                        .loadDiskFileSynchronously()
                        .resizable()
                        .placeholder{
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 95)
                        .cornerRadius(10)
                        .onTapGesture {
                            isFullScreen1 = true
                        }
                        .sheet(isPresented: $isFullScreen1) {
                            FullScreenImageView(imageURL: imgaeURL[1])
                                .onDisappear{
                                    isFullScreen1 = false
                                }
                        }
                }
                if imgaeURL.count >= 3 {
                    
                    KFImage(imgaeURL.last)
                        .loadDiskFileSynchronously()
                        .resizable()
                        .placeholder{
                            ProgressView()
                                .frame(width: 100, height: 95)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .onTapGesture {
                            isFullScreen2 = true
                        }
                            .sheet(isPresented: $isFullScreen2) {
                                FullScreenImageView(imageURL: imgaeURL.last ?? URL(fileURLWithPath: ""))
                                    .onDisappear{
                                        isFullScreen2 = false
                                    }
                            }
                }
                
            }
        }
        .onAppear{
            print(imgaeURL)
        }

    }
}

//#Preview {
//    RestorantAndBarView(imgaeURL: [URL(string: "")]!)
//}

