//
//  Responses.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import ObjectMapper

typealias CustomMappable = Mappable & CustomStringConvertible

// MARK: - BaseResponse<T: Mappable>
class BaseResponse<T: Mappable>: CustomMappable {
    var status: Int?
    var message: String?
    var sessionId: String?
    var result: T?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        sessionId <- map ["session_id"]
        result <- map["result"]
    }
}

// MARK: - EmptyResponse
class EmptyResponse: CustomMappable {
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {}
}

// MARK: - ReportAuditResponse
class ReportAuditResponse: CustomMappable {
    var errors: [ReportAuditError]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        errors <- map["errors"]
    }
}

class ReportAuditError: CustomMappable {
    var status: Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
    }
}
