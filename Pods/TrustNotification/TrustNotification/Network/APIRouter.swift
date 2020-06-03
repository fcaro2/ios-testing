//
//  APIRouter.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 26-11-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case confirmMessage(parameters: Parameterizable)
    
    var path: String {
        switch self {
        case .confirmMessage:
            return "/notification/confirmmessage"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .confirmMessage:
            return .post
        default:
            return .get
        }
    }
    var parameters: Parameters {
        switch self {
        case .confirmMessage(let parameters):
            return parameters.asParameters
        default:
            return [:]
        }
    }
    func asURLRequest() throws -> URLRequest {
        var baseURLAsString: String = ""
        
        switch self {
        case .confirmMessage:
            baseURLAsString = API.confirmMessageUrl
        }
        
        guard let url = URL(string: baseURLAsString) else {
            return URLRequest(url: URL(string: "")!)
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        print(urlRequest)
        
        switch self {
        case .confirmMessage:
            if let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken")  {
                print(bearerToken)
                urlRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
            }
        default:
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        switch self {
            case .confirmMessage:
                print(parameters)
                return try JSONEncoding.default.encode(urlRequest, with: parameters)
            default:
                return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
