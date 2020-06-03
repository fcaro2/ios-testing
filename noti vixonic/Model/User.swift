//
//  User.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import ObjectMapper
import RealmSwift

typealias MappableObject = Object & Mappable

// MARK: - Gender
enum Gender: String {
    case male
    case female
    
    var icon: UIImage? {
        switch self {
        case .male: return UIImage(named: "ifUser13356511")
        case .female: return UIImage(named: "path3326")
        }
    }
    
    var asInt: Int {
        switch self {
        case .male: return 0
        case .female: return 1
        }
    }
}

// MARK: - User
class User: MappableObject, PrimaryKeyable {
    typealias KeyType = String
    
    @objc dynamic var id: String? = "1"
    
    @objc dynamic var dni: String?
    @objc dynamic var country: String?
    
    @objc dynamic var birthDate: String?
    @objc dynamic var genderAsString: String?
    @objc dynamic var givenName: String?
//    @objc dynamic var middleName: String?
    @objc dynamic var familyName: String?
    
    @objc dynamic var profileAsString: String?
    @objc dynamic var profile: Profile?
    
    @objc dynamic var phone_number: String?
    @objc dynamic var email: String?

    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        dni <- map["dni"]
        country <- map["address.country"]
        birthDate <- map["birthdate"]
        genderAsString <- map["gender"]
        givenName <- map["name"]
        phone_number <- map["phone_number"]
        email <- map["email"]
        familyName <- map["last_name"]
        profileAsString <- map["profile"]
        
        if let profileAsString = profileAsString {
            profile = Profile(JSONString: profileAsString)
        }
    }
    
    override static func primaryKey() -> String? {
        return primaryKeyIdentifier
    }
}

// MARK: - ProfileDataSource
extension User: ProfileDataSource {
    var userEmail: String? {
        return email
    }
    
    var userPhone: String? {
        return phone_number
    }
    
    var userDni: String? {
        return dni
    }
    
    var completeName: String? {
        return "\(givenName ?? .empty) \(familyName ?? .empty)"
    }
    
    var name: String? {
        return "\(givenName ?? .empty)"
    }
    
    var lastName: String? {
        return "\(familyName ?? .empty)"
    }
    
    var gender: Gender? {
        guard let genderAsString = genderAsString else {
            return nil
        }
        
        return Gender(rawValue: genderAsString)
    }
}
