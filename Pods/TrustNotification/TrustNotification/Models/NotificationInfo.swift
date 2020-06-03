//
//  NotificationData.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 05-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation
class NotificationInfo{
    
    var bearerToken: String?
    var messageID: String?
    var trustID: String?
    var type: String?
    var dialogNotification: NotificationDialog?
    var videoNotification: VideoNotification?
}
