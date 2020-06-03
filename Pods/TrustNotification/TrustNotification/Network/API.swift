//
//  API.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 26-11-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift
import AlamofireObjectMapper

// MARK: -  Typealias
typealias CompletionHandler = (()->Void)?
typealias SuccessHandler<T> = ((T)-> Void)?


enum StatusCode: Int {
    case invalidToken = 401
}

enum API {
    static let confirmMessageUrl = "https://api.trust.lat/notifications"
}


extension API {
    static func call<T: Mappable>(responseDataType: T.Type, resource: APIRouter, onResponse: CompletionHandler = nil, onSuccess: SuccessHandler<T> = nil, onFailure: CompletionHandler = nil) {
        request(resource).responseObject {
            (response: DataResponse<T>) in
            print("API.call() Response: \(response)")
            if let onResponse = onResponse {
                onResponse()
            }
            switch(response.result) {
            case .success(let response):
                guard let onSuccess = onSuccess else {
                    return
                }
                onSuccess(response)
            case .failure(_):
                guard let onFailure = onFailure else {
                    return
                }
                onFailure()
            }
        }
    }
    static func callAsJSON(resource: APIRouter, onResponse: CompletionHandler = nil, onSuccess: CompletionHandler = nil, onFailure: CompletionHandler = nil) {
        request(resource).responseJSON {
            (response: DataResponse<Any>) in
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
    }
}
