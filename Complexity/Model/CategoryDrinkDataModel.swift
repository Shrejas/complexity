//
//  CategoryDrinkDataModel.swift
//  Complexity
//
//  Created by IE14 on 26/04/24.
//

import Foundation

struct CategoryDrinkDataModel: Codable, Identifiable,Equatable {
    var id = UUID()
    var brandName, drinkName: String?
    var category: Category?
    var subCategory: String?
    var imageURL: String?

    enum CodingKeys: String, CodingKey {
        case brandName = "Brand_name"
        case drinkName = "Drink_Name"
        case category = "Category"
        case subCategory = "Sub_category"
        case imageURL = "Image_URL"
    }

    init(brandName: String? = nil, drinkName: String? = nil, category: Category? = nil, subCategory: String? = nil, imageURL: String? = nil) {
        self.brandName = brandName
        self.drinkName = drinkName
        self.category = category
        self.subCategory = subCategory
        self.imageURL = imageURL
    }
}

enum Category: String, Codable {
    case beer = "Beer"
    case cider = "Cider"
    case cocktail = "Cocktail"
    case liqueur = "Liqueur"
    case other = "OTHER"
    case sake = "Sake"
    case spirit = "Spirit"
    case tea = "Tea"
    case wine = "Wine"
}
