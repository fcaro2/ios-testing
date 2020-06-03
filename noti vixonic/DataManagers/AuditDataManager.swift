//
//  AuditDataManager.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import Audit
import TrustDeviceInfo
import CoreTelephony
import SystemConfiguration.CaptiveNetwork

// MARK: - AuditDataManagerProtocol
protocol AuditDataManagerProtocol: NSObjectProtocol {
    func createLoginAudit()
}

// MARK: - AuditDataManager
class AuditDataManager: NSObject, AuditDataManagerProtocol {
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
 
    func createLoginAudit() {
        guard let savedTrustId = Identify.shared.getTrustID() else { return }
        let connectionType = checkReachable() ?? ""
        let ssidConnection = getWiFiSsid() ?? ""
        
        TrustAudit.shared.createAudit(trustID: savedTrustId, connectionType: connectionType, connectionName: ssidConnection, type: "trust identify", result: "success", method: "createLoginAudit", operation: "login")
    }
}

// MARK: - Connection Data
extension AuditDataManager {
    //Get connection type
    private func checkReachable() -> String? {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if (isNetworkReachable(with: flags)) {
            print(flags)
            if flags.contains(.isWWAN) {
                return "MOBILE"
            }
            else {
                return "WIFI"
            }
        }
        else if (!isNetworkReachable(with: flags)) {
            print("Sorry, No connection")
            print(flags)
            return "DISCONNECTED"
        }
        return "Error in connection data"
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    // Get internet ssid
    func getWiFiSsid() -> String? {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if (isNetworkReachable(with: flags)) {
            print(flags)
            if flags.contains(.isWWAN) {
                let networkInfo = CTTelephonyNetworkInfo()
                let carrierType = networkInfo.serviceCurrentRadioAccessTechnology
                if carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyLTE") }) != nil {
                     print ("Wwan : 4G")
                    return "4G"
                }
                else if carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyGPRS") }) != nil || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyEdge") }) != nil  || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyCDMA1x") }) != nil {
                    print("Wwan : 2G")
                    return "2G"
                }
                else if carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyWCDMA") }) != nil || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyHSDPA") }) != nil  || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyHSUPA") }) != nil || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyCDMAEVDORev0") }) != nil  || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyCDMAEVDORevA") }) != nil || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyCDMAEVDORevB") }) != nil || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyeHRPD") }) != nil  {
                    print ("Wwan : 3G")
                    return "3G"
                }
            }
            else { //Return wifi connection name
                var ssid: String?
                if let interfaces = CNCopySupportedInterfaces() as NSArray? {
                    for interface in interfaces {
                        if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                            ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                            break
                        }
                    }
                }
                return ssid
            }
        }
        else if (!isNetworkReachable(with: flags)) { //No internet, return disconnected
            print("Sorry, No connection")
            print(flags)
            return "DISCONNECTED"
        }
        return "UNKNOWN"
    }
}


//    @objc dynamic public var auditType: String = ""
//    @objc dynamic public var platform: String = "" //iOS
//    @objc dynamic public var application: String = ""
//    @objc dynamic public var source: Source?
//        @objc dynamic public var trustID: String = "" ok
//        @objc dynamic public var appName: String = "" ok
//        @objc dynamic public var bundleID: String = ""
//        @objc dynamic public var latitude: String = ""
//        @objc dynamic public var longitude: String = ""
//        @objc dynamic public var connectionType: String = ""
//        @objc dynamic public var connectionName: String = ""
//        @objc dynamic public var appVersion: String = ""
//        @objc dynamic public var deviceName: String = ""
//        @objc dynamic public var osVersion: String = ""
//    @objc dynamic public var transaction: Transaction?
//        @objc dynamic public var type: String = ""
//        @objc dynamic public var result: String = ""
//        @objc dynamic public var timestamp: Int = 1
//        @objc dynamic public var method: String = ""
//        @objc dynamic public var operation: String = ""


