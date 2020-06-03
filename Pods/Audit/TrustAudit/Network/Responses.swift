//
//  Responses.swift
//  TrustAudit
//
//  Created by Kevin Torres on 8/14/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import ObjectMapper

// MARK: - TrustID
public class TrustID: Mappable, CustomStringConvertible {
    var status = false
    var message: String?
    var trustID: String?
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        trustID <- map["trustid"]
    }
}

// MARK: - CreateAuditResponse
public class CreateAuditResponse: Mappable, CustomStringConvertible {
    var status: String?
    var message: String?
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
    }
}

// MARK: - ClientCredentials
public class AuditClientCredentials: Mappable, CustomStringConvertible {
    public var accessToken: String?
    public var tokenType: String?
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        accessToken <- map["access_token"]
        tokenType <- map["token_type"]
    }
}
