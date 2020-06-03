//
//  OAuth2Manager.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import p2_OAuth2

// MARK: - OAuth2ManagerProtocol
protocol OAuth2ManagerProtocol: AnyObject {
    func authorizeUser(from context: AnyObject)
    func silentAuthorize(from context: AnyObject)
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func clearTokens()
}

// MARK: - OAuth2ManagerOutputProtocol
protocol OAuth2ManagerOutputProtocol: AnyObject {
    func onAuthorizeSuccess()
    func onAuthorizeFailure(with errorMessage: String)
    func onSilentAuthorizeSuccess()
    func onSilentAuthorizeFailure()
}

// MARK: - OAuth2Manager
class OAuth2Manager: OAuth2ManagerProtocol {
    
    weak var managerOutput: OAuth2ManagerOutputProtocol?
    
    func authorizeUser(from context: AnyObject) {
        let acrValues = "autoidentify"
        let parameters = [
            "acr_values": acrValues,
            "Autentia-Client-Id": API.clientId
        ]
        
        OAuth2ClientHandler.shared.authConfig.authorizeEmbedded = true
        OAuth2ClientHandler.shared.authConfig.authorizeContext = context
        
        guard let authorizer = OAuth2ClientHandler.shared.authorizer as? OAuth2Authorizer else {
            managerOutput?.onAuthorizeFailure(with: "OAuth2Authorizer has not been initialized")
            
            return
        }
        
        guard let url = try? OAuth2ClientHandler.shared.authorizeURL(params: parameters) else {
            managerOutput?.onAuthorizeFailure(with: "Oauth2 authorizeURL has not been initialized")
            
            return
        }
        
        guard let viewController = context as? UIViewController else {
            return
        }
        
        guard let web = try? authorizer.authorizeSafariEmbedded(from: viewController, at: url) else {
            managerOutput?.onAuthorizeFailure(with: "Failed authentification using embedded Safari Web Browser")

            return
        }
        
        OAuth2ClientHandler.shared.afterAuthorizeOrFail = {
            [weak self] authParameters, error in
            
            guard let self = self else {
                return
            }
            
            guard authParameters != nil else {
                print("Error: \(error!)")
                
                guard !web.isBeingDismissed else {
                    self.managerOutput?.onAuthorizeFailure(with: error!.description)
                    
                    return
                }
                
                web.dismiss(animated: true) {
                    self.managerOutput?.onAuthorizeFailure(with: error!.description)
                }
                
                return
            }
            
            print(authParameters!)
            
            web.dismiss(animated: true) {
                self.managerOutput?.onAuthorizeSuccess()
            }
        }
    }
    
    func silentAuthorize(from context: AnyObject) {
        OAuth2ClientHandler.shared.authorizeEmbedded(from: context) {
            [weak self] _, error in
            
            guard let self = self else {
                return
            }
            
            guard error == nil else {
                self.managerOutput?.onSilentAuthorizeFailure()
                return
            }
            self.managerOutput?.onSilentAuthorizeSuccess()
        }
    }
    
    func getAccessToken() -> String? {
        return OAuth2ClientHandler.shared.accessToken
    }
    
    func getRefreshToken() -> String? {
        return OAuth2ClientHandler.shared.refreshToken
    }
    
    func clearTokens() {
        OAuth2ClientHandler.shared.forgetTokens()
    }
}
