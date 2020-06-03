//
//  SessionMenuInteractor.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import TrustDeviceInfo
import Audit

// MARK: - Interactor
class SessionMenuInteractor: SessionMenuInteractorProtocol {
    
    weak var interactorOutput: SessionMenuInteractorOutput?
    
    var oauth2Manager: OAuth2ManagerProtocol?
    var userDataManager: UserDataManagerProtocol?
    
    func changeEnvironment(environment: String) {
        if environment == "test" {
            Identify.shared.set(currentEnvironment: .test)
            TrustAudit.shared.set(currentEnvironment: .test)
        }
        if environment == "prod" {
            Identify.shared.set(currentEnvironment: .prod)
            TrustAudit.shared.set(currentEnvironment: .prod)
        }
    }
    
    func authorizeUser(from context: AnyObject) {
        oauth2Manager?.authorizeUser(from: context)
    }
    
    func getUserProfile() {
        let parameters = ProfileParameters(accessToken: OAuth2ClientHandler.shared.accessToken)
        
        API.call(
            responseDataType: User.self,
            resource: .getProfile(parameters: parameters),
            onResponse: {
                [weak self] in
                
                guard let self = self else {
                    return
                }
                
                self.interactorOutput?.onGetUserProfileResponse()
            }, onSuccess: {
                [weak self] userData in
                
                guard let self = self else {
                    return
                }
                
                self.userDataManager?.add(user: userData) {
                    self.interactorOutput?.onUserDataSaved()
                    self.interactorOutput?.onGetUserProfileSuccess()
                }
            }, onFailure: {
                [weak self] in
                
                guard let self = self else {
                    return
                }
                
                self.interactorOutput?.onGetUserProfileFailure(with: .defaultAlertMessage)
            }
        )
    }
}

// MARK: - OAuth2ManagerOutputProtocol
extension SessionMenuInteractor: OAuth2ManagerOutputProtocol {
    func onSilentAuthorizeSuccess() {
        print("onSilentAuthorizeSuccess")
    }
    
    func onSilentAuthorizeFailure() {
        print("onSilentAuthorizeFailure")
    }
    
    func onAuthorizeSuccess() {
        interactorOutput?.onAuthorizeSuccess()
    }
    
    func onAuthorizeFailure(with errorMessage: String) {
        interactorOutput?.onAuthorizeFailure(with: errorMessage)
    }
}
