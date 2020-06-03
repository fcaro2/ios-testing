//
//  APIManager.swift
//  TrustAudit
//
//  Created by Kevin Torres on 8/14/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Alamofire

// MARK: - APIManagerProtocol
protocol APIManagerProtocol: AnyObject {
    var managerOutput: APIManagerOutputProtocol? {get set}
    
    func getClientCredentials(with parameters: AuditClientCredentialsParameters)
    func createAudit(with parameters: CreateAuditParameters)
}

// MARK: - APIManagerOutputProtocol
protocol APIManagerOutputProtocol: AnyObject {
    func onClientCredentialsResponse()
    func onClientCredentialsSuccess(responseData: AuditClientCredentials)
    func onClientCredentialsFailure()
    
    func onCreateAuditResponse()
    func onCreateAuditSuccess(responseData: CreateAuditResponse, parameters: CreateAuditParameters)
    func onCreateAuditFailure()
}

// MARK: - APIManager
class APIManager: APIManagerProtocol {
    weak var managerOutput: APIManagerOutputProtocol?
    
    func getClientCredentials(with parameters: AuditClientCredentialsParameters) {
        API.call(
            responseDataType: AuditClientCredentials.self,
            resource: .clientCredentials(parameters: parameters),
            onResponse: {
                [weak self] in
                guard let self = self else {return}
                self.managerOutput?.onClientCredentialsResponse()
            }, onSuccess: {
                [weak self] responseData in
                guard let self = self else {return}
                self.managerOutput?.onClientCredentialsSuccess(responseData: responseData)
            }, onFailure: {
                [weak self] in
                guard let self = self else {return}
                self.managerOutput?.onClientCredentialsFailure()
            }
        )
    }
    
    func createAudit(with parameters: CreateAuditParameters) {
        API.call(
            responseDataType: CreateAuditResponse.self,
            resource: .createAudit(parameters: parameters),
            onResponse: {
                [weak self] in
                guard let self = self else {return}
                print("API call create audit parameters: \(parameters)")
                self.managerOutput?.onCreateAuditResponse()
            }, onSuccess: {
                [weak self] responseData in
                guard let self = self else {return}
                print("API call create audit parameters: \(parameters)")
                self.managerOutput?.onCreateAuditSuccess(responseData: responseData, parameters: parameters)
            }, onFailure: {
                [weak self] in
                guard let self = self else {return}
                self.managerOutput?.onCreateAuditFailure()
            }
        )
    }
}
