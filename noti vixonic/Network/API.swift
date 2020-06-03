//
//  API.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

enum StatusCode: Int {
    case accepted = 202
    case alreadyReported = 208
}

enum API {
    static let baseURL = "https://atenea.trust.lat/oauth"
    static let clientId = "1e9237a9-143b-4d4e-a7c5-4c5f6fce633d"
}

extension API {
    static func call<T: Mappable>(responseDataType: T.Type, resource: APIRouter, onResponse: CompletionHandler = nil, onSuccess: SuccessHandler<T> = nil, onFailure: CompletionHandler = nil) {
        
        let retrier = OAuth2RetryHandler(oauth2: OAuth2ClientHandler.shared)
        SessionManager.default.adapter = retrier
        SessionManager.default.retrier = retrier
        
        SessionManager.default.request(resource).responseObject {
            (response: DataResponse<T>) in
            
            print("API.call() Response: \(response)")
            
            onResponse?()
            
            switch (response.result) {
            case .success(let response):
                onSuccess?(response)
            case .failure(_):
                onFailure?()
            }
        }
    }
    
    static func callAsJSON(resource: APIRouter, onResponse: CompletionHandler = nil, onSuccess: CompletionHandler = nil, onFailure: CompletionHandler = nil) {
        
        let retrier = OAuth2RetryHandler(oauth2: OAuth2ClientHandler.shared)
        SessionManager.default.adapter = retrier
        SessionManager.default.retrier = retrier
        
        SessionManager.default.request(resource).responseString {
            (response: DataResponse<String>) in
            print("API.callAsJSON() Response as JSON: \(response)")

            if let onResponse = onResponse {
                onResponse()
            }

            switch (response.result) {
            case .success(_):
                guard let onSuccess = onSuccess else {
                    return
                }

                onSuccess()
            case .failure(_):
                guard let onFailure = onFailure else {
                    return
                }

                onFailure()
            }
        }
        
//        SessionManager.default.request(resource).responseJSON {
//            (response: DataResponse<Any>) in
//
//            print("API.callAsJSON() Response as JSON: \(response)")
//
//            if let onResponse = onResponse {
//                onResponse()
//            }
//
//            switch (response.result) {
//            case .success(_):
//                guard let onSuccess = onSuccess else {
//                    return
//                }
//
//                onSuccess()
//            case .failure(_):
//                guard let onFailure = onFailure else {
//                    return
//                }
//
//                onFailure()
//            }
//        }
    }
}
