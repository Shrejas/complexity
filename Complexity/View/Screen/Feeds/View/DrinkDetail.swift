//
//  SubCategoryView.swift
//  Complexity
//
//  Created by IE12 on 25/04/24.
//

import SwiftUI
import Kingfisher

struct DrinkDetail: View {

    @Environment(\.presentationMode) var presentationMode
    @State var categoryDrinkItems = [CategoryDrinkDataModel]()
    @State var filterCategoryDrinkItems = [CategoryDrinkDataModel]()
    @State  var categoryDrinkItem: CategoryDrinkDataModel = CategoryDrinkDataModel()
    @Binding var drinkDetail:Drinks?
    @StateObject var viewModel: DrinkViewModel = DrinkViewModel()
    @State var brandName = ""
    @State private var isSearching = false

    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoding {
                    BrandDetailSkeltonView(isSkeletonUIPresenting: viewModel.isLoding)
                        .padding(.top, 10)
                } else {
                    VStack {
                        SearchBarView(searchText: $viewModel.searchText, isSearching: $isSearching, isLoading: .constant(false))
                            .padding(.top, 10)
                        ScrollView (.vertical, showsIndicators: false){

                            let drinks = viewModel.filterDrinks

                            if drinks.count == 0 {
                                VStack(alignment: .center) {
                                    Text("No data availabe")
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.gray)
                                        .font(Font.system(size: 16))
                                        .padding(.top, 100)
                                }
                            } else {

                                LazyVGrid(
                                    columns: [
                                        GridItem(.flexible(minimum:100)),
                                        GridItem(.flexible(minimum:100)),
                                        GridItem(.flexible(minimum:100)),

                                    ],
                                    spacing: 5
                                ) {
                                    ForEach(drinks, id: \.drinkId) { item in
                                        VStack {
                                            KFImage(URL(string: item.drinkImage ?? ""))
                                                .loadDiskFileSynchronously()
                                                .resizable()
                                                .placeholder{
                                                    ProgressView()
                                                }
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(40)
                                                .onTapGesture {
                                                    drinkDetail = item
                                                    presentationMode.wrappedValue.dismiss()
                                                }
                                            Text(item.drinkName ?? "")
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
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .onChange(of: viewModel.searchText, perform: { value in
                        viewModel.searchResult()
                    })
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error!"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Drink Name")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()

                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color._626465)
                        }
                    }
                }
            }
            .onAppear {
                Task.detached(priority: .background) {
                    await self.viewModel.getDrinkName(brandName: brandName)
                }
            }
        }
    }
}



