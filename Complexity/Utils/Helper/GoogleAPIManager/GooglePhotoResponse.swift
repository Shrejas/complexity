//
//  GooglePhotoResponse.swift
//  Complexity
//
//  Created by IE14 on 03/05/24.
//

import Foundation

struct GooglePhotoResponse : Codable {
    let result: Result
}


struct Result: Codable {
    let photos: [Photo]
}

