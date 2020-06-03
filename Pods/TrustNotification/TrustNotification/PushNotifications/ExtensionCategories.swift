//
//  ExtensionCategories.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 10-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation
//import UserNotifications
//import FirebaseCore
//import FirebaseMessaging
import TrustDeviceInfo

extension PushNotificationsInit{
    public func registerCustomNotificationCategory(title1: String, title2: String, title3: String, title4: String, title5: String, title6: String) {
        //Buttons
        let firstAction = UNNotificationAction(identifier: "url", title:  title1, options: [.foreground])
        let secondAction = UNNotificationAction(identifier: "mail", title:  title2, options: [.foreground])
        let thirdAction = UNNotificationAction(identifier: "call", title:  title3, options: [.foreground])
        
        let auxurl = UNNotificationAction(identifier: "url2", title:  title4, options: [.foreground])
        let auxmail = UNNotificationAction(identifier: "mail2", title:  title5, options: [.foreground])
        let auxcall = UNNotificationAction(identifier: "call2", title:  title6, options: [.foreground])
        
        //Notification Categories
        let firstCategory =  UNNotificationCategory(
            identifier: "url",
            actions: [firstAction],
            intentIdentifiers: [],
            options: []
        )
        let secondCategory =  UNNotificationCategory(
            identifier: "mail",
            actions: [secondAction],
            intentIdentifiers: [],
            options: []
        )
        let thirdCategory =  UNNotificationCategory(
            identifier: "call",
            actions: [thirdAction],
            intentIdentifiers: [],
            options: []
        )
        let fourthCategory =  UNNotificationCategory(
            identifier: "url-mail",
            actions: [firstAction,secondAction],
            intentIdentifiers: [],
            options: []
        )
        let fifthCategory =  UNNotificationCategory(
            identifier: "mail-url",
            actions: [secondAction, firstAction],
            intentIdentifiers: [],
            options: []
        )
        let sixthCategory =  UNNotificationCategory(
            identifier: "url-call",
            actions: [firstAction, thirdAction],
            intentIdentifiers: [],
            options: []
        )
        let seventhCategory =  UNNotificationCategory(
            identifier: "call-url",
            actions: [thirdAction, firstAction],
            intentIdentifiers: [],
            options: []
        )
        let eigthCategory =  UNNotificationCategory(
            identifier: "mail-call",
            actions: [secondAction, thirdAction],
            intentIdentifiers: [],
            options: []
        )
        let ninethCategory =  UNNotificationCategory(
            identifier: "call-mail",
            actions: [thirdAction, secondAction],
            intentIdentifiers: [],
            options: []
        )
        let tenthCategory =  UNNotificationCategory(
            identifier: "url-url",
            actions: [firstAction, auxurl],
            intentIdentifiers: [],
            options: []
        )
        let eleventhCategory =  UNNotificationCategory(
            identifier: "mail-mail",
            actions: [secondAction, auxurl],
            intentIdentifiers: [],
            options: []
        )
        let twelvethCategory =  UNNotificationCategory(
            identifier: "call-call",
            actions: [firstAction, auxurl],
            intentIdentifiers: [],
            options: []
        )
        
        
        UNUserNotificationCenter.current().setNotificationCategories([firstCategory, secondCategory, thirdCategory, fourthCategory, fifthCategory, sixthCategory, seventhCategory, eigthCategory, ninethCategory, tenthCategory, eleventhCategory, twelvethCategory])
    }
}
