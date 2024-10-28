//
//  DrinkDetailProfileViewModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 30/07/24.
//

import Foundation
import IQAPIClient

@MainActor
final class DrinkDetailProfileViewModel: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var errrorMessage: String = ""
    @Published public var isShowAlert: Bool = false
    @Published public var drinkInfo: DrinkInfo?
    @Published public var relatedPost: [FeedPost] = []
    @Published public var selectedDetailPost: FeedPost?
    
    public func getDrinksData(drinkId: Int) {
        isLoading = true
        IQAPIClient.getDrinkData(drinkId: drinkId, completionHandler: { httpURLResponse,result in
            self.isLoading = false
            switch result {
            case .success(let data):
                self.drinkInfo = data.drinkInfo
                self.getRelatedDrinksFeed(drinkId: drinkId)
                break
            case .failure(let error):
                self.errrorMessage = error.localizedDescription
                self.isShowAlert = true
                break
            }
        })
    }
    
    private func getRelatedDrinksFeed(drinkId: Int) {
        IQAPIClient.getRelatedDrinksFeed(drinkId: drinkId, pageIndex: 1, pageSize: 5, completionHandler: { httpURLResponse, result in
            switch result {
            case .success(let data):
                self.relatedPost = data.post
                self.selectedDetailPost = data.post.first
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}
