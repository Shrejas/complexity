//
//  CategoryView.swift
//  Complexity
//
//  Created by IE12 on 25/04/24.
//

import SwiftUI
import Kingfisher

struct BrandDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isImageClick: Bool = false
    @State var categoryDrinkItems = [CategoryDrinkDataModel]()
    @Binding var brandName:String
    @StateObject var viewModel: BrandViewModel = BrandViewModel()
    @State private var isSearching = false
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoding {
                    BrandDetailSkeltonView(isSkeletonUIPresenting: viewModel.isLoding)
                        .padding(.top, 10)
                }
                else {
                    VStack {
                        SearchBarView(searchText: $viewModel.searchText, isSearching: $isSearching, isLoading: .constant(false))
                            .padding(.top, 10)

                        ScrollView (.vertical, showsIndicators: false) {

                            let brands = viewModel.filterBrands

                            if brands.count == 0 {
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

                                    if brands.count > 0 {
                                        ForEach(brands, id: \.brandName) { item in
                                            VStack {
                                                KFImage(URL(string: item.brandImage))
                                                    .loadDiskFileSynchronously()
                                                    .resizable()
                                                    .placeholder{
                                                        ProgressView()
                                                    }
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(40)
                                                    .onTapGesture {
                                                        brandName = item.brandName
                                                        presentationMode.wrappedValue.dismiss()
                                                    }
                                                Text(item.brandName)
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
                                .padding(4)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onChange(of: viewModel.searchText, perform: { value in
                        viewModel.searchResult()
                    })
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error!"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Brand Name")
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
            .navigationBarBackButtonHidden(true)
            .onAppear {
                Task.detached(priority: .background) {
                    await self.viewModel.getBrandName()
                }
            }
        }
    }
}

#Preview {
    BrandDetail(brandName: .constant(""))
}

