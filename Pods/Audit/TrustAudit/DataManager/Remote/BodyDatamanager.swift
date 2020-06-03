//
//  BodyDatamanager.swift
//  TrustAudit
//
//  Created by Kevin Torres on 9/24/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit
import CoreLocation

protocol BodyDataManagerProtocol: NSObjectProtocol {
    func getLat() -> Double
    func getLng() -> Double
}

public class BodyDataManager: NSObject, BodyDataManagerProtocol {
    
    let locationManager = CLLocationManager()
    
    // MARK: - Get Latitude and Longitude
    func getLat() -> Double {
        let lat = locationManager.location?.coordinate.latitude
        if lat != nil {
            return lat ?? 1
        }
        else {
            return 1
        }
    }
    
    func getLng() -> Double {
        let lng = locationManager.location?.coordinate.longitude
        if lng != nil {
            return lng ?? 1
        }
        else {
            return 1
        }
    }
}

extension BodyDataManager: CLLocationManagerDelegate {
    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> CLLocation {
        let location = locations.last!
        return location
    }
}
