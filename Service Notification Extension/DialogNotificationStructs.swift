//
//  DialogNotificationStructs.swift
//  Service Notification Extension
//
//  Created by Kevin Torres on 15-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import Foundation

struct GenericStringNotification: Codable{
    /**
     The notification type can be:
     
     - notificationDialog
     - notificationVideo
     - notificationBody
    */
    var type: String!
    
    var typeDialog: String?
    
    /**
     If the type is "notificationDialog" this variable will be not null. For further information see the NotificationDialog struct documentation.
     */
    var notificationVideo: String?
    
    var notificationDialog: String?
    
}

/**
 This stucts are used to parse the json from a generic notification data
 
 **JSON Description:**
 ```json
 {
 "application_name": "app name",
 "trust_id": "trust if from the phone that receive notifications",
 
 "data":{
    "type":"notification",
    "title":"Title",
    "body":"Body"
 },
 "priority": "high",
 "apns": {
    "payload": {
        "aps": {
            "mutable-content":1,
            "sound": "default",
            "category":"buttons",
            "alert":{
                "title":"Alerta notificación",
                "body":"cuerpo notificación"
            },
            "badge":1
        },
        "url-scheme":"https://google.com",
        "data":{
        "type" : notification Type,
        "notification Type":{ content from a notification dialog }
        }
    }
 }
 }
 ```
 
 The notification type can be:
 
- notificationDialog
- notificationVideo
 
 According to the type the last field from the prior JSON can change, the different options will be further describe.
 
*/
struct GenericNotification: Codable {
    
    /**
     The notification type can be:
     
     - notificationDialog
     - notificationVideo
    */
    var type: String!
    
    var typeDialog: String?
    /**
     If the type is "notificationDialog" this variable will be not null. For further information see the NotificationDialog struct documentation.
     */
    var notificationVideo: VideoNotification?
    
    var notificationDialog: NotificationDialog?
    
    enum CodingKeys: String, CodingKey {
        case type
        case notificationDialog
        case notificationVideo
        case typeDialog = "type_dialog"
    }
}

/**
 This stuct is used to parse the dialog notification data
 
 **JSON Description:**
 ```json
 "data":{
    "type" : "notificationDialog",
    "notificationDialog":{
        "text_body" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus velit erat, cursus et facilisis eu, ultricies id lorem. Etiam bibendum viverra eros et convallis. ",
        "image_url" : "https://i.pinimg.com/474x/0e/7d/a0/0e7da046f859b046242d9771a37cbc7b--wallpaper-space-iphone--wallpaper.jpg",
        "isPersistent" : true,
        "isCancelable" : true,
        "buttons":[
            {
                "type":"url",
                "text":"Google",
                "color":"#F25E60",
                "action":"https://www.google.cl"
            },
            {
                 "type":"call",
                 "text":"Call",
                 "color":"#F25E60",
                 "action":"tel:5551234"
            }
        ]
 }
 ```
 
 */
struct NotificationDialog: Codable {
    
    /**
     This variable content the text of the notification. If is a banner notification this variable will be empty ("")
     */
    var textBody: String
    /**
     This variable contents the url to load the image for the dialog or banner notification
     */
    var imageUrl: String
    /**
     If this value is true, if you touch outside the dialog the notification still open, otherwise, the notification close on touching outside the dialog
     */
    var isPersistent: Bool = true
    /**
     If this value is true, a close button is available, otherwise, there is no close button. If both properties: persistence and cancelability are set to not close the notification, the notification can be closed only by closing the app.
     */
    var isCancelable: Bool = true
    
    /**
     This variable may or may not contains an array of buttons, the maximun number of button can be two, if this number is bigger, the dialog will show only two.
     */
    var buttons: [Button]?
    
    enum CodingKeys: String, CodingKey {
        case buttons
        case imageUrl = "image_url"
        case textBody = "text_body"
    }
}

/**
 This stuct is used to parse the video notification data
 
 **JSON Description:**
 ```json
 "data":{
 "type" : "notificationVideo",
 "notificationVideo" : {
     "video_url" : "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
     "min_play_time" : 5.0,
     "isPersistent" : true,
     "buttons" : [
     {
         "type":"call",
         "text":"Call",
         "color":"#F25E60",
         "action":"tel:5551234"
     }
     ]
 }

 }
 ```
 
 */
struct VideoNotification: Codable {
    
    /**
     This variable contents the url to load the video for the notification
     */
    var videoUrl: String
    
    /**
     This variable sets a protected time, during this time the user will not be able to close the notification. Just can block the audio. There is a label that shows the remaining time to the enable the close button.
     */
    var minPlayTime: String
    
    var isPersistent: Bool? = true
    
    var isSound: Bool? = true
    
    var isPlaying: Bool? = true
    /**
     This variable may or may not contains an array of buttons, the maximun number of button can be two, if this number is bigger, the dialog will show only two.
     */
    var buttons: [Button]
    
    enum CodingKeys: String, CodingKey {
        case buttons
        case videoUrl = "video_url"
        case minPlayTime = "min_play_time"
        case isSound
        case isPlaying
    }
}

/**
 This stuct is used to parse the body notification data
 
 **JSON Description:**
 ```json
 "data":{
 "type" : "notificationBody",
 "notificationBody" : {
 "text_title" : "",
 "text_body" : "",
 "image_url" : "",
     "buttons" : [
     {
     "type" : "",
     "text" : "",
     "color" : "",
     "action" : ""
     }
 ]

 }
 ```
 
 */


/**
 This stuct is used to parse the buttons data
 
 **JSON Description:**
 ```json
 "buttons":{
     "type" : "",
     "text" : "",
     "color" : "",
     "action" : ""
 }
 ```
 
 */
struct Button: Codable {
    var type: String
    var text: String
    var color: String
    var action: String
}
