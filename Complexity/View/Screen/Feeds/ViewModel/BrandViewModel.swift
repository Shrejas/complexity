//
//  CategoryViewModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 13/05/24.
//

import Foundation
import IQAPIClient
import Alamofire

@MainActor
final class BrandViewModel: ObservableObject {

    var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isLoding: Bool = false
    
    @Published var searchText: String = ""

    private var localBrands: [Brands] = []
    @Published var filterBrands: [Brands] = []

    func getBrandName() {
        isLoding = true
        IQAPIClient.getBrands { httpUrlResponse, result  in
            DispatchQueue.main.async {
                self.isLoding = false
                switch result {
                case .success(let data):
                    self.localBrands = data.brands
                    self.searchResult()

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    if self.errorMessage == "Response could not be serialized, input data was nil or zero length." {
                        self.getBrandName()
                    } else {
                        self.showAlert.toggle()
                    }
                }
            }
        }
    }

    func searchResult() {
        if searchText.isEmpty {
            filterBrands = localBrands
        } else {
            let filters =  localBrands.filter { item in
                let searchText = searchText.lowercased()
                return item.brandName.lowercased().contains(searchText)
            }
            filterBrands = filters
        }
    }
}
