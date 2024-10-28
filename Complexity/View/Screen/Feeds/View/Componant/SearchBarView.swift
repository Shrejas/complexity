//
//  SearchBarView.swift
//  Complexity
//
//  Created by IE Mac 05 on 18/05/24.
//

import SwiftUI
import Kingfisher

struct SearchBarView: View {
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 10)
                    .foregroundColor(Color._8A8E91)
                
                TextField("Search here", text: $searchText)
                    .font(.muliFont(size: 17, weight: .semibold))
                    .foregroundColor(Color._8A8E91)
                    .disableAutocorrection(true)
                    .padding(.trailing, 5)
                    .accentColor(.black)
                    .onTapGesture {
                        isSearching = true
                    }
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }, label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(Color._8A8E91)
                    })
                    .padding(.trailing, 10)
                } else {
                    if isLoading {
                        ProgressView()
                    }
                }
            }
            .frame(height: 40)
            .background(Color._F4F6F8)
            .cornerRadius(10)

        }
    }
}

#Preview {
    SearchBarView(searchText: .constant("Amber"), isSearching: .constant(true), isLoading: .constant(true))
}

struct SearchResultList: View {
    
    let drinkInfo: [DrinkInfo]
    @Binding var selectedDrinkId: Int
    @Binding var showNoResult: Bool
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 0) {
                if !drinkInfo.isEmpty {
                    ForEach(drinkInfo, id: \.drinkId) { item in
                        LazyVStack {
                            VStack {
                                HStack {
                                    if let image = item.drinkImage, let name = item.drinkName, let brandName = item.brandName {
                                        KFImage(URL(string: (image)))
                                            .resizable()
                                            .placeholder {
                                                ProgressView()
                                            }
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 68, height: 68)
                                            .cornerRadius(34)
                                            .padding(.leading, 20)
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(name)
                                                .padding(.leading, 20)
                                            Text(brandName)
                                                .padding(.leading, 20)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .onTapGesture {
                                if let drinkId = item.drinkId {
                                    self.selectedDrinkId = drinkId
                                }
                            }
                        }
                        .cornerRadius(10)
                        .background(Color._F4F6F8)
                    }
                } else {
                    if showNoResult {
                        VStack(alignment: .center, spacing: 30) {
                            Image("searchImage")
                                .resizable()
                                .foregroundColor(Color._8A8E91)
                                .frame(width: 70, height: 70)
                                .padding(.top, 100)
                            Text("Sorry, we couldn't find any results")
                                .multilineTextAlignment(.center)
                                .font(.muliFont(size: 25, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .cornerRadius(10)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                    }
                }
            }.padding(.bottom, 120)
        }
        .background(Color._F4F6F8)
    }
}


