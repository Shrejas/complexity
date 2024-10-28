//
//  AsyncListStore.swift
//  Habit SwiftUI
//
//  Created by Iftekhar on 3/13/23.
//

import Foundation
import SwiftUI
import GoogleSignIn

class AsyncListStore<T>: ObservableObject where T: Identifiable, T: Decodable {

    @Published var models: [T]

    @Published var isRefreshing = false

    @Published var isLoadingMore = false
    @Published var enableLoadMore = false
    @Published var error: Error? = nil
  
    private let pageSize = 10

    init(models: [T] = []) {
        self.models = models
        refresh()
    }

    func refresh() {

        guard !isRefreshing else {
            return
        }

        let page: Int = 1
        enableLoadMore = false
        isRefreshing = true
        error = nil
        
        request(page: page, size: pageSize, completion: { result in
            self.isRefreshing = false
            switch result {
            case .success(let success):
                self.models = success
                self.enableLoadMore = (success.count == self.pageSize)

            case .failure(let failure):
                self.error = failure
                if self.error?.localizedDescription == "Response could not be serialized, input data was nil or zero length." {
                    self.loadMore()
                }
            }
        })
    }

    func loadMore() {

        guard !isRefreshing, !isLoadingMore, enableLoadMore, models.count.isMultiple(of: pageSize) else {
            return
        }

        let page: Int = (models.count / pageSize) + 1
        isLoadingMore = true
        error = nil

        request(page: page, size: pageSize, completion: { result in

            let isReallyMoreLoading: Bool = self.enableLoadMore && self.isLoadingMore
            self.isLoadingMore = false

            guard isReallyMoreLoading else {
                return
            }

            switch result {
            case .success(let success):
                self.models += success
                self.enableLoadMore = (success.count == self.pageSize)
            case .failure(let failure):
                self.error = failure
                 if self.error?.localizedDescription == "Response could not be serialized, input data was nil or zero length."{
                    self.loadMore()
                }
            }
        }) 
    }

    open func request(page: Int, size: Int, completion: @escaping (Swift.Result<[T], Error>) -> Void) {
        fatalError("\(#function) has not been implemented by \(Self.self)")
    }
}

