//
//  FeedStore.swift
//  Complexity
//
//  Created by IftekharSSD on 17/05/24.
//

import Foundation
import SwiftUI
import IQAPIClient
import GoogleSignIn

class FeedStore: AsyncListStore<FeedPost> {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    override func request(page: Int, size: Int, completion: @escaping (Swift.Result<[FeedPost], Error>) -> Void) {
        IQAPIClient.getFeed(pageIndex: page, pageSize: size) { httpUrlResponse, result  in
            switch result{
            case .success(let data):        
                completion(.success(data.post ?? []))
            case .failure(let error):
                if let httpResponse = httpUrlResponse as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if statusCode == 401 {
                        self.logoutButtonAction()
                    }
                }
                completion(.failure(error))
            }
        }
    }
    
    private func logoutButtonAction(){
        GIDSignIn.sharedInstance.signOut()
        UserDefaultManger.clearAllData()
        NotificationCenter.default.post(name: .userLogoutNotification, object: nil)
        KeychainManager.token = nil
        appDelegate.setWindowGroup(AnyView(ContentView()))
        
    }
}
