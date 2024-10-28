//
//  RestorantAndBarView.swift
//  Complexity
//
//  Created by IE14 on 01/05/24.
//

import SwiftUI
import GoogleMaps
import GooglePlaces
import Kingfisher

struct RestorantAndBarView: View {

    var imgaeURL:URL
    var body: some View {
        VStack{
            KFImage(imgaeURL)
                .loadDiskFileSynchronously()
                .resizable()
                .placeholder{
                    ProgressView()
                    .frame(width: 90, height: 90)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .cornerRadius(10)
        }
        .onAppear{
            print(imgaeURL)
        }
    }
}

#Preview {
    RestorantAndBarView(imgaeURL: URL(string: "")!)
}
