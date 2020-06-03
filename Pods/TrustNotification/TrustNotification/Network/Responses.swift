//
//  Responses.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 26-11-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation
import ObjectMapper

typealias CustomMappable = Mappable & CustomStringConvertible

// MARK: - BaseResponse<T: Mappable>
class BaseResponse<T: Mappable>: Mappable, CustomStringConvertible {
    var code: Int?
    var status: String?
    var message: String?
    var count: String?
    var data: T?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        status <- map["status"]
        message <- map ["message"]
        count <- map["count"]
        data <- map["data"]
    }
}

//MARK: - CallbackResponse

class CallbackResponse: Mappable{
    
    var status: String?
    var code: Int?
    var message: String?
    var resource: String?
    var total: Int?
    var data: NotificationData?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        code <- map["code"]
        message <- map["message"]
        resource <- map["resource"]
        total <- map["total"]
        data <- map["data"]
    }
}

class NotificationData: Mappable{
    var id: Int?
    var deviceId: Int?
    var trustId: String?
    var messageId: String?
    var action: String?
    var errorMessage: String?
    var type: String?
    var status: Int?
    var actionButton: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        deviceId <- map["device_id"]
        trustId <- map["trust_id"]
        messageId <- map["message_id"]
        action <- map["action"]
        errorMessage <- map["error_message"]
        type <- map["type"]
        status <- map["status"]
        actionButton <- map["action_button"]
    }
}
