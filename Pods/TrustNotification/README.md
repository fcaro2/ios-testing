

# Trust Technologies 
![image](https://avatars2.githubusercontent.com/u/42399326?s=200&v=4)  
  
   
# Description  

The Trust Notification Library allows you to send push notifications to your users quick and easy. Adopting this library, you can send different messages to multiple devices.

We support multiple sorts of messages grouped into four categories:

* **Body Notifications:** This is the simplest type of notification, is a simple push notification with a title and a one or two-lines body.

* **Dialog Notifications:** This message presents a title and a body just as the Body Notification but also has an image and buttons with possible actions for your users. All these actions dynamically set.

* **Banner Notifications:** This notification is just like Dialog Notification but with only one difference: there is no notification body,  just the image, and buttons.

* **Video Notifications:** This message shows a video with a protected view time. After the protected time, the user is allowed to close the notification but not before. This notification also has two actionable buttons.

The image below presents the all four notification types.

![](https://i.imgur.com/oUmhVcu.png)

## Multimedia Specifications

To get a good visualization of the multimedia content. The images and videos have to satisfy the following dimension constraints.

* **Dialog Notifications:** Image with 340x320 aspect ratio
* **Banner Notifications:** Image with 340x400 aspect ratio
* **Video Notifications:** Video with 320x515 aspect ratio
  
# Implementation  

## Adding the Pod

If you don’t have any pods, run the following command into the terminal at the project's location:

```
pod init 
```
The command generates a file called Podfile. Open this file and add the following lines to the Podfile:

``` Swift
source 'https://github.com/trusttechnologies/trustnotificationpodspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'NameApp' do
	...
	pod 'TrustNotification'
	...
end
```
Then again in the command line console, run:

```
pod install 
```

This will install the library code into your project.

## Linking with the firebase project 

The Trust Notification Service uses a Firebase project. Please contact us at app@trust.lat to configure a project for your app. We will send you a file ``` GoogleService-Info.plist  ```. Add this file to your project.

## Service Notification Extension

The Service Notification Extension handles the view of the notification outside the app. In the image below we have an example.

![](https://i.imgur.com/itaKP66.jpg =250x)

To support this content, add the Service Notification Extension to your project. To do this, add a new target to the project clicking on File ---> New ---> Target ...  ---> Notification Service Extension. The procedure is in the images below.

	
  ![enter image description here](https://lh3.googleusercontent.com/J3huLEycnzlTDQgRX_alMyD2MEGxICPfupjQyuxIQZimAZyBpsZxjotLxyRJqm8aaKx9_Rnum2Y "Add Target" =650x)

![enter image description here](https://lh3.googleusercontent.com/7VZq29G9oDubKPbtInzwGuDeti6dWgn806HiipuuZ7T68D9Lre_QeGPJKRUKeVASpg3A5kj2_wc "Select extension" =650x)

# Initialize  
    
This initiation establishes by default that automatic audits are not initiated  

```Swift
import TrustNotification

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	let notifications = PushNotificationsInit()

}

extension  AppDelegate{

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		...
	    notifications.clientId = "clientId"
            notifications.clientSecret = "clientSecret"
            notifications.accessGroup = "accessGroup"
            notifications.serviceName = "serviceName"
            
            notifications.initTrustNotifications() 
		...

		return true

	}
}
```

```Swift
func applicationDidBecomeActive(_ application: UIApplication) {
	...
	notifications.clearBadgeNumber()
	...
}
```

Once the TrustID is saved call the next methods

```Swift
notifications.registerForRemoteNotifications()
        
notifications.firebaseConfig(application: UIApplication.shared)
        
notifications.registerCustomNotificationCategory(title1: "Ir", title2: "Mail", title3: "Llamar", title4: "Ir", title5: "Mail", title6: "Llamar")
```

Add this files in Notification Service Extension 

DialogNotificationsStructs.siwft
```Swift
import Foundation

struct GenericNotification: Codable {
    
    var type: String!
    
    var notificationVideo: String?
    
    var notificationDialog: String?
    
    var notificationBody: BodyNotification?
    
}

struct NotificationDialog: Codable {
    
    var textBody: String
   
    var imageUrl: String
    
    var isPersistent: Bool
    
    var isCancelable: Bool
    
    var buttons: [Button]?
    
    enum CodingKeys: String, CodingKey {
        case buttons
        case imageUrl = "image_url"
        case isPersistent = "isPersistent"
        case isCancelable = "isCancelable"
        case textBody = "text_body"
    }
}

struct VideoNotification: Codable {
    
    var videoUrl: String
    
    var minPlayTime: Float
    
    var isPersistent: Bool
    
    var buttons: [Button]
    
    enum CodingKeys: String, CodingKey {
        case buttons
        case videoUrl = "video_url"
        case minPlayTime = "min_play_time"
        case isPersistent = "isPersistent"
        
    }
}

struct BodyNotification: Codable {
    var textTitle: String
    var textBody: String
    var imageUrl: String
    var buttons: [Button]
    
    enum CodingKeys: String, CodingKey {
        case buttons
        case textTitle = "text_title"
        case textBody = "text_body"
        case imageUrl = "image_url"
        
    }
}

struct Button: Codable {
    var type: String
    var text: String
    var color: String
    var action: String
}

```

ParseNotifications.swift
```Swift
import Foundation
import UIKit

// MARK: -Parse Generic Notification

func parseNotification(content: [AnyHashable: Any]) -> GenericNotification {
    
    //take the notification content and convert it to data
    guard let jsonData = try? JSONSerialization.data(withJSONObject: content["data"], options: .prettyPrinted)
        else {
            print("Parsing notification error: Review your JSON structure")
            return GenericNotification()
    }
    
    //decode the notification with the structure of a generic notification
    let jsonDecoder = JSONDecoder()
    guard let notDialog = try? jsonDecoder.decode(GenericNotification.self, from: jsonData) else {
        print("Parsing notification error: Review your JSON structure")
        return GenericNotification() }
    
    return notDialog
}

//MARK: -Parse Dialog
func parseDialog(content: GenericNotification) -> NotificationDialog {
    
    print(content)
    let contentAsString = content.notificationDialog?.replacingOccurrences(of: "\'", with: "\"", options: .literal, range: nil)
    print("--------Change structure with double quotes-----------")
    print(contentAsString)
    
    let jsonDecoder = JSONDecoder()
    let dialogNotification = try! jsonDecoder.decode(NotificationDialog.self, from: contentAsString!.data(using: .utf8)!)

    return dialogNotification
}

//MARK: -PARSE VIDEO
func parseVideo(content: GenericNotification) -> VideoNotification {
    print(content)
    let contentAsString = content.notificationVideo?.replacingOccurrences(of: "\'", with: "\"", options: .literal, range: nil)
    print("--------Change structure with double quotes-----------")
    print(contentAsString)

    let jsonDecoder = JSONDecoder()
    let videoNotification = try! jsonDecoder.decode(VideoNotification.self, from: contentAsString!.data(using: .utf8)!)

    return videoNotification
}

```
Replace content of NotificationService.swift
```Swift
import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
        var bestAttemptContent: UNMutableNotificationContent?
        
        var downloadTask: URLSessionDownloadTask?
    
        var url:String?
        
        override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
            self.contentHandler = contentHandler
            bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
            
            let genericNotification = parseNotification(content: request.content.userInfo)
            switch genericNotification.type {
                case "notificationBody":
                    url = genericNotification.notificationBody?.imageUrl
                case "notificationDialog":
                    let dialogNotification = parseDialog(content: genericNotification)
                    url = dialogNotification.imageUrl
                case "notificationVideo":
                    let videoNotification = parseVideo(content: genericNotification)
                    url = videoNotification.videoUrl
                default:
                    print("error: must specify a notification type")
            }
                                        
    
            if let urlString = url, let fileUrl = URL(string: urlString) {
                // Download the attachment
                URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                    if let location = location {
                    // Move temporary file to remove .tmp extension
                        let tmpDirectory = NSTemporaryDirectory()
                        let tmpFile = "file://".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                        let tmpUrl = URL(string: tmpFile)!
                        try! FileManager.default.moveItem(at: location, to: tmpUrl)

                        // Add the attachment to the notification content
                        if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                            self.bestAttemptContent?.attachments = [attachment]
                        }
                    }
                    // Serve the notification content
                    self.contentHandler!(self.bestAttemptContent!)
                }.resume()
            }
                             
        }
        
        override func serviceExtensionTimeWillExpire() {
            // Called just before the extension will be terminated by the system.
            // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
            if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
                contentHandler(bestAttemptContent)
            }
        }

}

```
Add images to project assets.  
[download the notifications icons here](https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-notification_library/raw/master/Notification%20icons.zip)

Call images with these names:
```
audio_disabled_icon
audio_enabled_icon
close_icon
```
  
  
# Permissions  
  
For the correct use of this library, it is necessary to grant the application overwriting permission

Enable capabilities: 
```
	Keychain sharing 
	
	Push Notification
```	
  
For more details about Keycahin sharing, see the following link in the permissions section
[https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-identify_library](https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-identify_library)
