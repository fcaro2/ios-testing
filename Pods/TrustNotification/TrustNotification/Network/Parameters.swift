//
//  Parameters.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 26-11-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Parameterizable
protocol Parameterizable {
    var asParameters: Parameters {get}
}

//MARK:- LegacyProfile parameters
struct CallbackParameters: Parameterizable {
    
    var messageID: String?
    var action: String?
    var status: String?
    var trustID: String?
    var errorMessage: String?
    var type: String?
    var actionButton: String?
    
    var asParameters: Parameters {
        guard
            let messageID = messageID,
            let action = action,
            let status = status,
            let trustID = trustID,
            let errorMessage = errorMessage,
            let type = type,
            let actionButton = actionButton else {
            return [:]
        }
        return [
            "message_id": messageID,
            "action": action,
            "status": status,
            "trust_id" : trustID,
            "error_message": errorMessage,
            "type": type,
            "action_button": actionButton
        ]
    }
}

