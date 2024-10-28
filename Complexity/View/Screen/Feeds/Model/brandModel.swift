//
//  CategoryModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 14/05/24.
//

import Foundation

struct BrandModel: Codable{
    let brands: [Brands]
    let isSucceed: Bool
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case brands = "brands"
        case isSucceed = "isSucceed"
        case message = "message"
    }
}
struct Brands: Codable{
    let brandName: String
    let brandImage: String
    
    private enum CodingKeys: String, CodingKey {
        case brandName = "brandName"
        case brandImage = "brandImage"
    }
}
