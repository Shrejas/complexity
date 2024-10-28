//
//  FindDetailsView.swift
//  Complexity
//
//  Created by IE12 on 25/04/24.
//

import SwiftUI

struct FindListView: View {
    var body: some View {
        VStack {
            Text("Nearby Restaurants, Bars, and Stores")
                .font(.system(size: 17, weight: .bold))
                .padding(.leading, 19)
            HStack {
            
                ScrollView(.horizontal,showsIndicators: false) { // Enable horizontal scrolling
                    HStack {
                        ForEach(0..<10) { _ in // Use ForEach to repeat views
                            RestorantAndBarView()
                        }
                    }
                    .padding(20)
                }
            }
            .frame(height: 80)
            .onAppear {
                
            }
            
            Spacer()
            
        }
    }
}

#Preview {
    FindListView()
}





