////
////  FeedSearchViewModel.swift
////  Complexity
////
////  Created by IE12 on 02/07/24.



import Foundation
import Combine
import IQAPIClient

final class FeedSearchViewModel: ObservableObject {
    
    @Published var feedSearchData: FeedModel?
    @Published var shouldShowApiAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var searchResults: [FeedPost] = []
    @Published var isLoadingMore = false
    @Published var enableLoadMore = false
    @Published var error: Error? = nil
    @Published var isRefreshing = false
    @Published var searchDrinksData: [DrinkInfo] = []
    @Published var showNoResultDrinkSearch: Bool = false

    let pageSize = 10
    var pageIndex = 1

    @Published var searchText: String = "" {
        didSet {
            feedSearchData?.searchText = searchText
        }
    }

    private var debounceTimer: Timer?

    func fetchData(query: String, placeId: String, searchKeyword: String) {
        isLoading = true
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.pageIndex = 1 // Reset page index
            self.request(page: self.pageIndex, size: self.pageSize, placeId: placeId, query: query, searchKeyword: searchKeyword) { result in
                self.isLoading = false
                self.isRefreshing = false
                switch result {
                case .success(let data):
                    self.feedSearchData = data
                    self.searchResults = data.post ?? []
                    self.enableLoadMore = (data.post?.count == self.pageSize)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.shouldShowApiAlert.toggle()
                }
            }
        }
    }

    func loadMore(completion: @escaping (Swift.Result<FeedModel, Error>) -> Void) {
        guard !isLoadingMore, enableLoadMore, searchResults.count.isMultiple(of: pageSize) else {
            return
        }

        pageIndex += 1
        isLoadingMore = true
        error = nil

        request(page: pageIndex, size: pageSize, placeId: "", query: "", searchKeyword: searchText) { result in
            self.isLoadingMore = false
            switch result {
            case .success(let data):
                self.searchResults += data.post ?? []
                self.enableLoadMore = (data.post?.count == self.pageSize)
                completion(.success(data))
            case .failure(let error):
                self.error = error
                completion(.failure(error))
            }
        }
    }

    private func request(page: Int, size: Int, placeId: String, query: String, searchKeyword: String, completion: @escaping (Swift.Result<FeedModel, Error>) -> Void) {
        IQAPIClient.getSearchFeed(pageIndex: page, pageSize: size, placeID: placeId, drinkName: query, searchKeyword: searchKeyword) { _, result in
            completion(result)
        }
    }
    
    func getSearchDrinkData(drinkName: String) {
        IQAPIClient.getSearchDrinkData(drinkName: drinkName, completionHandler: { httpURLResponse,result in
            switch result {
            case .success(let data):
                if data.drinks.isEmpty {
                    self.showNoResultDrinkSearch = true
                    self.searchDrinksData = []
                } else {
                    self.showNoResultDrinkSearch = false
                    let sortedDrinks = data.drinks.sorted { $0.drinkName ?? "" < $1.drinkName ?? "" }
                    self.searchDrinksData = sortedDrinks
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getDrinkName(brandName: String){
        IQAPIClient.getDrinkName(brandName: brandName) { httpUrlResponse, result  in
                switch result {
                case .success(_): break
                   
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.shouldShowApiAlert.toggle()
                }
        }
    }

}
