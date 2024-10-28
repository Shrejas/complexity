//
//  DrinkModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 14/05/24.
//

import Foundation

struct DrinkModel: Codable {

    let message: String?
        let isSucceed: Bool?
        let drinks: [Drinks]?

    private enum CodingKeys: String, CodingKey {
        case message = "message"
        case isSucceed = "isSucceed"
        case drinks = "drinks"
    }

}

struct Drinks: Codable, Equatable {
    let drinkId: Int
    let drinkImage: String?
    let subCategory: String?
    var drinkName: String?
    let category: String?
    let brandName: String?
    
    private enum CodingKeys: String, CodingKey {
        case drinkId = "drinkId"
        case drinkImage = "drinkImage"
        case subCategory = "subCategory"
        case drinkName = "drinkName"
        case category = "category"
        case brandName = "brandName"
    }
    
    
    static func == (lhs: Drinks, rhs: Drinks) -> Bool {
        return lhs.drinkName == rhs.drinkName
        
    }
    
}

struct SearchedDrinks: Codable {
    let drinks: [DrinkInfo]
}

struct Drink: Codable {
    let drinkInfo: DrinkInfo
}

struct DrinkInfo: Codable, Hashable {

    let userAverageRating: Int?
    let overallAverageRating: Double?
    let overallRatingsCount: Int?
    let drinkId: Int?
    let drinkName: String?
    let brandName: String?
    let drinkImage: String?
    let category: String?
    let subCategory: String?
    let likesCount: Int?
    let userRatingsCount: Int?

    private enum CodingKeys: String, CodingKey {
        case userAverageRating = "userAverageRating"
        case overallAverageRating = "overallAverageRating"
        case overallRatingsCount = "overallRatingsCount"
        case drinkId = "drinkId"
        case drinkName = "drinkName"
        case brandName = "brandName"
        case drinkImage = "drinkImage"
        case category = "category"
        case subCategory = "subCategory"
        case likesCount = "likesCount"
        case userRatingsCount = "userRatingsCount"
    }

}

struct RelatedDrinksFeed: Codable {
    let post: [FeedPost]
}

