//
//  CategoryView.swift
//  Complexity
//
//  Created by IE12 on 25/04/24.
//

import SwiftUI
import Kingfisher

struct CategoryView: View {

    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var isImageClick: Bool = false
    @State var categoryDrinkItems = [CategoryDrinkDataModel]()
    @Binding var categoryDrinkItem: CategoryDrinkDataModel
    @State private var isSearching = false

    var filteredItems: [CategoryDrinkDataModel] {
        if searchText.isEmpty {
            return categoryDrinkItems
        } else {
            return categoryDrinkItems.filter { item in
                if let brandName = item.brandName?.lowercased() {
                    let searchText = searchText.lowercased()
                    return brandName.contains(searchText)
                }
                return false
            }
        }
    }

    var body: some View {

        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 10)
                    .foregroundColor(Color._8A8E91)

                TextField("Search here", text: $searchText)
                    .font(.muliFont(size: 17, weight: .semibold))
                    .foregroundColor(Color._8A8E91)

                    .padding(.trailing,5)
                    .onTapGesture {
                        isSearching = true
                    }
                    .onChange(of: searchText) { _ in
                        if !isSearching {
                            isSearching = true
                        }
                    }
            }
            .frame(height: 40)

            .background(Color._F4F6F8)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)

            .overlay(
                HStack {
                    if isSearching {
                        Spacer()
                        Button(action: {
                            searchText = ""
                            isSearching = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color._8A8E91)
                                .padding(.trailing, 25)
                        }
                    }
                }
            )
        }
        .padding(.top,0)
        .padding(.bottom,-30)


        ScrollView (.vertical, showsIndicators: false) {

            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum:100)),
                    GridItem(.flexible(minimum:100)),
                    GridItem(.flexible(minimum:100)),
                ],
                spacing: 5
            ){
                ForEach(filteredItems) { item in
                    VStack {
                        KFImage(URL(string: item.imageURL ?? ""))
                            .loadDiskFileSynchronously()
                            .resizable()
                            .placeholder{
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(40)
                            .onTapGesture {
                                print("clikc")
                                categoryDrinkItem = item
                                presentationMode.wrappedValue.dismiss()
                            }
                        Text(item.brandName ?? "")
                            .frame(alignment: .center)
                            .lineLimit(2)
                            .font(.muliFont(size: 13, weight: .regular))
                            .foregroundColor(Color._626465)
                    }
                    .frame(maxWidth: .infinity ,minHeight: 120, maxHeight: 125)
                    .padding(4)
                    .background(Color._F4F6F8)
                    .cornerRadius(10)
                    .shadow(radius: 0.1)
                }
            }
            .padding(4)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Brand Name")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Custom Action")
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color._626465)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            getCategoryDrinkData()
        }
    }

    func getCategoryDrinkData(){
        let fileName = JsonFileName.categoryDrinkName
        if let jsonData: [CategoryDrinkDataModel] = LocalJsonManger.shared.loadLocalJSONData(fileName: fileName, type: [CategoryDrinkDataModel].self) {
            categoryDrinkItems = jsonData
        } else {
            print("Failed to load or decode JSON data.")
        }
    }
}



#Preview {
    CategoryView(categoryDrinkItem: .constant(CategoryDrinkDataModel()))
}

