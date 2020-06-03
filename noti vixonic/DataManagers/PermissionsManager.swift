//
//  PermissionsManager.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import UserNotifications

// MARK: - PermissionsManagerProtocol
protocol PermissionsManagerProtocol: AnyObject {
    func checkBothPermissions()
}

// MARK: - PermissionsManagerOutputProtocol
protocol PermissionsManagerOutputProtocol: AnyObject {
    func permissionsSuccess()
    func permissionsFail()
}

class PermissionsManager: PermissionsManagerProtocol {
    
    var isPushNotificationEnabled: Bool {
      guard let settings = UIApplication.shared.currentUserNotificationSettings
        else {
          return false
      }

        return UIApplication.shared.isRegisteredForRemoteNotifications
        && !settings.types.isEmpty
    }
    
    weak var managerOutput: PermissionsManagerOutputProtocol?

    func checkBothPermissions() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse { //Si fue autorizado pregunto por notification
            let notificationStatus = UIApplication.shared.isRegisteredForRemoteNotifications
            if !isPushNotificationEnabled { //Permiso notificacion aceptado?, no aceptado ->
                UNUserNotificationCenter.current().getNotificationSettings(){ (settings) in
                    if settings.authorizationStatus == .authorized{
                        self.managerOutput?.permissionsSuccess()
                    } else {
                         self.managerOutput?.permissionsFail()
                    }
                }
            } else {  //Go main screen
                //Show user profile
                managerOutput?.permissionsSuccess()
            }
        }
        else { //If user not accept permissions, show alert and close when user interact
            self.managerOutput?.permissionsFail()
        }
    }
    
}
