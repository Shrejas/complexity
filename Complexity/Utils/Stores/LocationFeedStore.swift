//
//  LocationFeedStore.swift
//  Complexity
//
//  Created by IftekharSSD on 24/05/24.
//

import Foundation
import SwiftUI
import IQAPIClient

class LocationFeedStore: AsyncListStore<FeedPost> {

    let placeId: String
    let drinkName: String

    private override init(models: [FeedPost] = []) {
        fatalError()
    }

    init(models: [FeedPost] = [], placeId: String = "", drinkName: String = "") {
        self.placeId = placeId
        self.drinkName = drinkName
        super.init(models: models)
    }

    override func request(page: Int, size: Int, completion: @escaping (Swift.Result<[FeedPost], Error>) -> Void) {
        IQAPIClient.getFeedWithPlaceId(placeId: placeId, drinkName: drinkName, pageIndex: page, pageSize: size){ httpUrlResponse, result  in
            switch result{
            case .success(let data):
                completion(.success(data.post ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

