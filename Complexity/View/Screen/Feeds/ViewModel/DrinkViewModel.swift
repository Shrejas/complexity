//
//  DrinkViewModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 14/05/24.
//

import Foundation
import IQAPIClient

@MainActor
final class DrinkViewModel: ObservableObject{

    @Published var showAlert: Bool = false
    var errorMessage: String = ""
    @Published var isLoding: Bool = false
    
    @Published var searchText: String = ""

    private var localDrinks: [Drinks] = []
    @Published var filterDrinks: [Drinks] = []

    func getDrinkName(brandName: String){
        isLoding = true
        IQAPIClient.getDrinkName(brandName: brandName) { httpUrlResponse, result  in
            DispatchQueue.main.async {
                self.isLoding = false
                switch result{

                case .success(let data):
                    self.localDrinks = data.drinks ?? []
                    self.searchResult()

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert.toggle()
                }
            }
        }
    }

    func searchResult() {
        if searchText.isEmpty {
            filterDrinks = localDrinks
        } else {
            let filters =  localDrinks.filter { item in
                let searchText = searchText.lowercased()
                if let drinkName = item.drinkName {
                    return drinkName.lowercased().contains(searchText)
                }

                return false
            }
            filterDrinks = filters
        }
    }
}


