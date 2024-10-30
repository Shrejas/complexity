//
//  IQAPIClient+Base.swift
//  Complexity
//
//  Created by IE Mac 05 on 06/05/24.
//

import SwiftUI
import Alamofire
import IQAPIClient
import Network
import Reachability


public enum IQNSURLServerError : Int {
    case accessTokenExpired = 100
    case invalidRefreshToken = 101
}

public extension IQAPIClient {
    
    static func configureAPIClient() {
        
        IQAPIClient.default.baseURL = URL(string: APIPath.baseUrl.rawValue)
        IQAPIClient.default.httpHeaders["Content-Type"] = "application/json"
        IQAPIClient.default.httpHeaders["Accept"] = "application/json"
        IQAPIClient.default.debuggingEnabled = true
        
        
        IQAPIClient.default.commonErrorHandlerBlock = { (request, requestParameters, responseData, error) in
            
            switch (error as NSError).code {
            case NSURLClientError.unauthorized401.rawValue:
                
                let window: UIWindow?
#if swift(>=5.1)
                if #available(iOS 13, *) {
                    window = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first(where: { $0.isKeyWindow })
                } else {
                    window = UIApplication.shared.keyWindow
                }
#else
                window = UIApplication.shared.keyWindow
#endif
                
                window?.rootViewController?.dismiss(animated: true, completion: nil)
                
            default:
                break
            }
        }
        
        
        IQAPIClient.default.responseModifierBlock = { (request, response1) in
            
            guard let response = response1 as? [String: Any] else {
                /// We seding success here because we do not have single format of API's response
                return .success(response1)
            }
            
            /// Handle Error cases
            if let statusCode = response["status"] as? Int {
                
                if statusCode >= 400 && statusCode < 500 {

                    if statusCode == NSURLClientError.unauthorized401.rawValue,
                       let message = response["message"] as? String {
                        let error = NSError(domain: "Server Error", code: IQNSURLServerError.accessTokenExpired.rawValue, userInfo:[NSLocalizedDescriptionKey: message])
                        return .error(error)
                    }

                    if statusCode == NSURLClientError.forbidden403.rawValue,
                       let message = response["message"] as? String {
                        // Handle refresh case
                        let error = NSError(domain: "Server Error", code: IQNSURLServerError.invalidRefreshToken.rawValue, userInfo:[NSLocalizedDescriptionKey: message])
                        return .error(error)
                    }

                    var errorMessage = "Client Error"

                    if let message = response["message"] as? String {
                        errorMessage = message
                    }

                    let error = NSError(domain: "Client Error", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    return .error(error)

                } else if statusCode >= 500 && statusCode < 600 {

                    if statusCode == NSURLServerError.internalServerError500.rawValue {
                        
                        var errorMessage = StringConstants.APIError.serverError
                        
                        if let message = response["message"] as? String {
                            if !message.isEmpty {
                                errorMessage = message
                            } else {
                                errorMessage = "Something went wrong"
                            }
                        }
                        
                        let error = NSError(domain:StringConstants.APIError.serverError, code:statusCode, userInfo:[ NSLocalizedDescriptionKey: errorMessage])
                        return .error(error)
                        
                    } else {
                        var errorMessage = StringConstants.APIError.serverErrorMessage
                        
                        if let message = response["message"] as? String {
                            errorMessage = message
                        }
                        
                        let error = NSError(domain:StringConstants.APIError.serverError, code:statusCode, userInfo:[ NSLocalizedDescriptionKey: errorMessage])
                        return .error(error)
                    }
                }
                
            } else if let error = response["error"] as? String {
                
                let error = NSError(domain:StringConstants.APIError.serverError, code: NSURLErrorBadServerResponse, userInfo:[NSLocalizedDescriptionKey: error])
                return .error(error)
            }
            
            return .success(response)
        }
    }
    
    @discardableResult
    func refreshableSendRequest<Success: Sendable>(path: String,
                                                   method: HTTPMethod = .get,
                                                   parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, forceMultipart: Bool = false, options: Options = [], completionHandler: @Sendable @escaping @MainActor  (_ httpURLResponse: HTTPURLResponse, _ result: Swift.Result<Success, Error>) -> Void) -> DataRequest {
        let json = parameters
        IQAPIClient.default.setUserAuthToken()
        return sendRequest(path: path, method: method, parameters: json, encoding: encoding,options: options) { (httpURLResponse, result: Swift.Result<Success, Error>) in
            
            completionHandler(httpURLResponse, result)
        }
    }
    
}
