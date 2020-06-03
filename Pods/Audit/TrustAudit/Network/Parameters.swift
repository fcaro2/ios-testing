//
//  Parameters.swift
//  TrustAudit
//
//  Created by Kevin Torres on 8/14/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Alamofire
import CoreTelephony
import RealmSwift

// MARK: - CreateAuditParameters
public class CreateAuditParameters: Object, Parameterizable {
    @objc dynamic public var localID: String = ""
    @objc dynamic public var auditType: String = ""
    @objc dynamic public var platform: String = "" //iOS
    @objc dynamic public var application: String = ""
    @objc dynamic public var source: Source?
    @objc dynamic public var transaction: Transaction?
    @objc dynamic public var location: Location?

    public var asParameters: Parameters {
        return [
            "type_audit": auditType,
            "platform": platform,
            "application": application,
            "source": source?.asParameters,
            "transaction": transaction?.asParameters,
            "location": location?.asParameters
        ]
    }
}

// MARK: - Source
public class Source: Object, Parameterizable {
    
    @objc dynamic public var trustID: String = ""
    @objc dynamic public var appName: String = ""
    @objc dynamic public var bundleID: String = ""
    @objc dynamic public var connectionType: String = ""
    @objc dynamic public var connectionName: String = ""
    @objc dynamic public var appVersion: String = ""
    @objc dynamic public var deviceName: String = ""
    @objc dynamic public var osVersion: String = ""
    @objc dynamic public var os: String = ""


    
    public var asParameters: Parameters {
        
        return [
            "trust_id": trustID,
            "app_name": appName,
            "bundle_id": bundleID,
            "os": os,
            "os_version": osVersion ?? .zero,
            "device_name": deviceName,
            "connection_type": connectionType,
            "connection_name": connectionName,
            "version_app": appVersion
        ]
    }
}

// MARK: - Transaction
public class Transaction: Object, Parameterizable {
    
    @objc dynamic public var type: String = ""
    @objc dynamic public var result: String = ""
    @objc dynamic public var timestamp: Int = 1
    @objc dynamic public var method: String = ""
    @objc dynamic public var operation: String = ""

    public var asParameters: Parameters {
        return [
            "type": type,
            "result": result,
            "timestamp": timestamp,
            "method": method,
            "operation": operation
        ]
    }
}

// MARK: - Location
public class Location: Object, Parameterizable {
    @objc dynamic public var latitude: String = ""
    @objc dynamic public var longitude: String = ""
    
        public var asParameters: Parameters {
        return [
            "lat_geo": latitude,
            "lon_geo": longitude,
        ]
    }
}

// MARK: - ClientCredentialsParameters
struct AuditClientCredentialsParameters: Parameterizable {
    var clientID: String?
    var clientSecret: String?
    
    let grantType = "client_credentials"
    
    public var asParameters: Parameters {
        guard
            let clientID = clientID,
            let clientSecret = clientSecret else {
                return [:]
        }
        
        return [
            "client_id": clientID,
            "client_secret": clientSecret,
            "grant_type": grantType
        ]
    }
}


