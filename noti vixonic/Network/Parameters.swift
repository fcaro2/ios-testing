//
//  Parameters.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import Alamofire

// MARK: - ProfileParameters
struct ProfileParameters: Parameterizable {
    var accessToken: String?
    
    var asParameters: Parameters {
        guard let accessToken = accessToken else {
            return [:]
        }
        
        return [
            "access_token": accessToken
        ]
    }
}

// MARK: - LogoutParameters
struct LogoutParameters: Parameterizable {
    var sessionID: String?
    var sessionState: String?
    
    var asParameters: Parameters {
        guard
            let sessionID = sessionID,
            let sessionState = sessionState else {
                return [:]
        }
        
        return [
            "session_id": sessionID,
            "session_state": sessionState,
            "post_logout_redirect_uri": "trust.vixonic.app://auth.id"
//            "post_logout_redirect_uri": "noti.vixonic.app://auth.id"
        ]
    }
}

// MARK: - UpdateProfileParameters
struct UpdateProfileParameters: Parameterizable {
    var names: String?
    var lastname: String?
    var surname: String?
    var birthDate: String?
    var nationality: String?
    var gender: String?
    
    var asParameters: Parameters {
        guard
            let names = names,
            let lastname = lastname,
            let surname = surname,
            let birthDate = birthDate,
            let nationality = nationality,
            let gender = gender else {
                return [:]
        }
        
        return [
            "type": "person",
            "attributes": [
                "names": names,
                "last_name": lastname,
                "sur_name": surname,
                "birthday": birthDate,
                "nationality": nationality,
                "gender": gender,
                "status": "alive",
                "verified": false,
            ]
        ]
    }
}
