//
//  Credential.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import ObjectMapper
import RealmSwift

// MARK: - Credential
class Credential: MappableObject {
    @objc dynamic var sub: String?
    @objc dynamic var iss: String?
    @objc dynamic var profileID: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        sub <- map["sub"]
        iss <- map["iss"]
        profileID <- map["profile_id"]
    }
}
