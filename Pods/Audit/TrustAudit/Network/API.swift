//
//  API.swift
//  TrustAudit
//
//  Created by Kevin Torres on 8/14/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

// MARK: - ResponseStatus Enum
public enum ResponseStatusT: String {
    case noChanges = "No hay cambios"
    case updated = "Datos actualizados"
    case error = "Ha ocurrido un error en el envío de datos"
}

// MARK: - StatusCode Enum
enum StatusCode: Int {
    case invalidToken = 401
}

// MARK: - API class
class API {
    static let baseURL = "https://api.trust.lat"    //Prod
    static let baseURLTest = "https://api-tst.trust.lat"    //Test

    static let clientCredentialsBaseURL = "https://atenea.trust.lat"    //Credentials Prod
    static let clientCredentialsBaseURLTest = "https://atenea-tst.trust.lat"    //Credentials Test

    static let apiVersion = "/api/v1"
}

extension API {
    // MARK: - handle(httpResponse)
    static func handle(httpResponse: HTTPURLResponse?, onExpiredAuthToken: CompletionHandler) {
        guard let httpResponse = httpResponse else {return}
        
        print("handle() httpResponse.statusCode: \(httpResponse.statusCode)")
        
        guard let statusCode = StatusCode(rawValue: httpResponse.statusCode) else {return}
        
        print("handle() statusCode: \(statusCode)")
        
        switch statusCode {
        case .invalidToken:
            guard let onExpiredAuthToken = onExpiredAuthToken else {return}
            onExpiredAuthToken()
        }
    }
    
    // MARK: - call<T: Mappable>(onResponse: CompletionHandler), onResponse without response data
    static func call<T: Mappable>(responseDataType: T.Type, resource: APIRouter, onResponse: CompletionHandler = nil, onSuccess: SuccessHandler<T> = nil, onFailure: CompletionHandler = nil) {
        request(resource).responseObject {
            (response: DataResponse<T>) in
            
            if let onResponse = onResponse {
                onResponse()
            }
            
            print(response.result)
            
            switch (response.result) {
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
    
    // MARK: - call<T: Mappable>(onResponse: SuccessHandler<DataResponse<T>>), onResponse with response data
    //    static func call<T: Mappable>(responseDataType: T.Type, resource: APIRouter, onResponse: SuccessHandler<DataResponse<T>> = nil, onSuccess: SuccessHandler<T> = nil, onFailure: CompletionHandler = nil) {
    //        request(resource).responseObject {
    //            (response: DataResponse<T>) in
    //
    //            if let onResponse = onResponse {
    //                onResponse(response)
    //            }
    //
    //            switch (response.result) {
    //            case .success(let response):
    //                guard let onSuccess = onSuccess else {
    //                    return
    //                }
    //
    //                onSuccess(response)
    //            case .failure(_):
    //                guard let onFailure = onFailure else {
    //                    return
    //                }
    //
    //                onFailure()
    //            }
    //        }
    //    }
    
    // MARK: - callAsJSON(onResponse: CompletionHandler), onResponse without response data
    static func callAsJSON(resource: APIRouter, onResponse: CompletionHandler = nil, onSuccess: SuccessHandler<Any> = nil, onFailure: CompletionHandler = nil) {
        request(resource).responseJSON {
            (response: DataResponse<Any>) in
            
            print("API.callAsJSON() Response as JSON: \(response)")
            
            if let onResponse = onResponse {
                onResponse()
            }
            
            switch (response.result) {
            case .success(let responseData):
                guard let onSuccess = onSuccess else {
                    return
                }
                
                onSuccess(responseData)
            case .failure(_):
                guard let onFailure = onFailure else {
                    return
                }
                
                onFailure()
            }
        }
    }
}
