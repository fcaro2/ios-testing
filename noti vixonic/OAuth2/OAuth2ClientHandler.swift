//
//  OAuth2ClientHandler.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import p2_OAuth2

struct OAuth2ClientHandler {
    private static var oauth2: OAuth2CodeGrant = {
        let clientId = "1e9237a9-143b-4d4e-a7c5-4c5f6fce633d"
        let clientSecret = "9b29505d-c374-4757-834f-b54441d5704b"
        
        let authorizeURI = "https://atenea.trust.lat/oauth/authorize"
        let tokenURI = "https://atenea.trust.lat/oauth/token"
        
        let redirectURI = "trust.vixonic.app://auth.id"

        let scope = "openid name dni phone_number last_name company_uid email"
        
        let oauth2 = OAuth2CodeGrant(
            settings: [
                "client_id": clientId,
                "client_secret": clientSecret,
                "authorize_uri": authorizeURI,
                "token_uri": tokenURI,
                "redirect_uris": [redirectURI],
                "scope": scope,
                ] as OAuth2JSON
        )
        
        oauth2.logger = OAuth2DebugLogger(.trace)
        
        return oauth2
    }()
    
    private init() {}
    
    static var shared: OAuth2CodeGrant {
        return oauth2
    }
}
