//
//  Profile.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import ObjectMapper
import RealmSwift

// MARK: - Profile
class Profile: MappableObject {
    var credentials = List<Credential>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        credentials <- (map["credentials"], ListTransformClass<Credential>())
    }
}
