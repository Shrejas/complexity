//
//  APIManger.swift
//  Complexity
//
//  Created by IE14 on 26/04/24.
//
import Foundation
import Reachability
import IQAPIClient

enum DataError: Error {
    case invalidURL
    case noData
    case decodingError
}

class  LocalJsonManger{
    
    static let shared = LocalJsonManger()
    
    func loadLocalJSONData<T: Decodable>(fileName: String, type: T.Type) -> T? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            return nil
        }
    }
    
}

enum APIError: Error {
    case invalidURL
    case noData
  
}

class NetworkManager: NSObject {
   
    var reachability: Reachability!
    static let sharedInstance: NetworkManager = {
        return NetworkManager()
    }()
    
  
static let shared = NetworkManager()

   private let baseURL = "https://api.example.com"
    
    func requestData<T: Decodable>(from endpoint: String, responseType: T.Type, completion: @escaping (Swift.Result<T, Error>) -> Void) {
        
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    override init() {
        super.init()
     
        do {
            // Initialise reachability
            reachability = try Reachability()
            // Register an observer for the network status
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(networkStatusChanged(_:)),
                name: .reachabilityChanged,
                object: reachability
            )
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        // Stop the network status notifier
        NetworkManager.sharedInstance.reachability.stopNotifier()
    }
    
    
    // Network is reachable
    static func isReachable() -> Bool {
        return NetworkManager.sharedInstance.reachability.connection != .unavailable
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if NetworkManager.sharedInstance.reachability.connection == .unavailable {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if NetworkManager.sharedInstance.reachability.connection == .cellular {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if NetworkManager.sharedInstance.reachability.connection == .wifi {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    
}
public extension IQAPIClient {
    
     func setUserAuthToken() {
        if let accessToken = UserDefaultManger.getToken() {
            IQAPIClient.default.httpHeaders["Authorization"] =  "Bearer " + accessToken
        }
    }
    
}
