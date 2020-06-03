//
//  PushNotificationsInit.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 21-01-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation
//import UserNotifications
//import FirebaseCore
//import FirebaseMessaging
import TrustDeviceInfo
import AVFoundation
import AVKit

// MARK: - VideoDownloadDataManagerOutputProtocol
extension PushNotificationsInit: VideoDownloadDataManagerOutputProtocol {
    func onDownloadSuccess(with url: URL) {
        notificationInfo.videoNotification?.videoUrl = url.absoluteString
        presentVideo(content: self.notificationInfo)
    }
    
    func onDownloadFailure() {
        //
    }
}

// MARK: - PushNotificationsInit
public class PushNotificationsInit: NSObject {
    var callbackDataManager: CallbackDataManagerProtocol? = CallbackDataManager()
    var videoDownloadDataManager: VideoDownloadDataManager? = VideoDownloadDataManager()
    
    func onNotificationArrive(data: NotificationInfo, action: String, state: String, errorMessage: String?) {
        callbackDataManager?.receptionConfirmation(data: data, action: "", state: state, errorMessage: nil)
    }
    
    func downloadVideo(data: NotificationInfo) {
        videoDownloadDataManager?.managerOutput = self
        videoDownloadDataManager?.downloadVideo(url: data.videoNotification!.videoUrl)
    }
    
    //MARK:- Private vars
    private var notificationInfo: NotificationInfo = NotificationInfo(){
        didSet{
            notificationInfo.trustID = KeychainWrapper.standard.string(forKey: "trustID")
            notificationInfo.bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken")
        }
    }
    
    func processNotification(userInfo: [AnyHashable : Any]){
        //if is a body notification - Notify: do nothing
        
        let genericNotification = parseStringNotification(content: userInfo)
        
        notificationInfo.messageID = (userInfo["gcm.message_id"] as! String)
        notificationInfo.type = genericNotification.type
        notificationInfo.trustID = KeychainWrapper.standard.string(forKey: "trustID")
        notificationInfo.bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken")
        
        let genericStringNotification = parseStringNotification(content: userInfo)
        notificationInfo.type = genericStringNotification.type
        switch genericStringNotification.type {
        case "dialog", "banner":
            let dialogNotification = parseDialog(content: genericStringNotification)
            notificationInfo.dialogNotification = dialogNotification
            presentDialog(content: notificationInfo)
        case "video":
            let videoNotification = parseVideo(content: genericStringNotification)
            notificationInfo.videoNotification = videoNotification
            guard let videoUrl = notificationInfo.videoNotification?.videoUrl else{
                return
            }
            if(videoUrl.isValidURL){
                downloadVideo(data: notificationInfo)
                //lottie iniciar animacion
            }
        default:
            print("error: must specify a notification type")
        }
    }
    
    
    /**
     This function is called by the UNUserNotificationCenterDelegate functions (if receive notification in foreground or background).
     
     - Parameters:
     - content: This is a generic notification that can have any kind of notification data, but for this function in particular, it is required a notification dialog tipe, for more information see the GenericNotification struct documentation
     
     ### Usage Example: ###
     ````
     presentDialog(content: genericNotification)
     ````
     */
    
    func presentDialog(content: NotificationInfo){

        if(verifyUrl(urlString: content.dialogNotification?.imageUrl)){
            let dialogVC = DialogRouter.createModule()
            dialogVC.loadView()
            dialogVC.modalPresentationStyle = .overCurrentContext
            dialogVC.data = content
            dialogVC.fillDialog()
            
            
            let topMostViewController = getTopViewController()
            let window = UIApplication.shared.keyWindow

            
            if topMostViewController is DialogViewController {
                topMostViewController.dismiss(animated: true, completion: {
                    let presentedViewController = window?.rootViewController?.presentedViewController
                    presentedViewController?.present(dialogVC, animated: true)
                })
            }
            else if topMostViewController is VideoViewController{
                topMostViewController.dismiss(animated: true, completion: {
                    let presentedViewController = window?.rootViewController?.presentedViewController
                    presentedViewController?.present(dialogVC, animated: true)
                })
            }
            else{
                topMostViewController.present(dialogVC, animated: true)
            }
            
            window?.makeKeyAndVisible()
        }
        else{
            onNotificationArrive(data: content, action: "", state: "_error", errorMessage: "image url unreachable")
        }
        
    }
    
    /**
     This function is called by the UNUserNotificationCenterDelegate functions (if receive notification in foreground or background).
     
     - Parameters:
     - content: This is a generic notification that can have any kind of notification data, but for this function in particular, it is required a notification video tipe, for more information see the GenericNotification struct documentation
     
     ### Usage Example: ###
     ````
     presentVideo(content: genericNotification)
     ````
     */
    
    func presentVideo(content: NotificationInfo){
        
        let videoVC = VideoRouter.createModule()
        videoVC.modalPresentationStyle = .overCurrentContext
        videoVC.loadView()
        videoVC.data = content
        videoVC.fillVideo()
        
        
        
        let topMostViewController = getTopViewController()
        let window = UIApplication.shared.keyWindow
        
        if topMostViewController is DialogViewController {
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(videoVC, animated: true)
            })
        }
        else if topMostViewController is VideoViewController{
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(videoVC, animated: true)
            })
        }
        else{
            topMostViewController.present(videoVC, animated: true)
        }
        
        window?.makeKeyAndVisible()
    }
    
    //para nueva vista de la maria
    func presentNewVideo(content: NotificationInfo) {
        
        guard let url = URL(string: content.videoNotification!.videoUrl ?? "") else {
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        controller.allowsPictureInPicturePlayback = true
        
        let topMostViewController = getTopViewController()
        let window = UIApplication.shared.keyWindow

        
        if topMostViewController is DialogViewController {
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(controller, animated: true){
                    if(content.videoNotification?.isPlaying ?? true){
                        player.play()
                    }
                    if(!(content.videoNotification?.isSound ?? false)){
                        player.isMuted = true
                    }
                }
            })
        }
        else if topMostViewController is VideoViewController{
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(controller, animated: true){
                    if(content.videoNotification?.isPlaying ?? true){
                        player.play()
                    }
                    if(!(content.videoNotification?.isSound ?? false)){
                        player.isMuted = true
                    }
                }
            })
        }else if topMostViewController is AVPlayerViewController{
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(controller, animated: true){
                    if(content.videoNotification?.isPlaying ?? true){
                        player.play()
                    }
                    if(!(content.videoNotification?.isSound ?? false)){
                        player.isMuted = true
                    }
                }
            })
        }
        else{
            topMostViewController.present(controller, animated: true){
                if(content.videoNotification?.isPlaying ?? true){
                        player.play()
                }
                if(!(content.videoNotification?.isSound ?? false)){
                        player.isMuted = true
                }
            }
        }
        
        window?.makeKeyAndVisible()

    }
}

// MARK: - Received Payload
extension PushNotificationsInit {
    public func getNotification(response: UNNotificationResponse) {
        guard response.notification.request.content.userInfo["data"] != nil else {return}
        notificationInfo.messageID = (response.notification.request.content.userInfo["gcm.message_id"] as! String)

        let notiInfo = parseStringNotification(content: response.notification.request.content.userInfo)
        let category = response.notification.request.content.categoryIdentifier
        self.notificationInfo.type = notiInfo.type
        
        onNotificationArrive(data: self.notificationInfo, action: "", state: "_success", errorMessage: nil)
        self.processNotification(userInfo: response.notification.request.content.userInfo)
    }
    
    public func getNotificationForeground(notification: UNNotification) {
        notificationInfo.messageID = (notification.request.content.userInfo["gcm.message_id"] as! String)
        onNotificationArrive(data: notificationInfo, action: "", state: "_success", errorMessage: nil)
        processNotification(userInfo: notification.request.content.userInfo)
    }
}

