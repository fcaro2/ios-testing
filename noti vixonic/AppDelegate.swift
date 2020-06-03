//
//  AppDelegate.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import TrustDeviceInfo
import Audit
import TrustNotification
import Sentry

import FirebaseMessaging
import FirebaseCore
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let accessGroup = "P896AB2AMC.trustID.appLib"
    let clientID = "9928b0e6-a656-4462-a937-b980cc84d011"
    let clientSecret = "76207d19-058f-40fe-9614-2e365837a8a1"
    let notifications = PushNotificationsInit()
    let serviceName = "defaultServiceName"
    
    var locationManager = CLLocationManager()
    var window: UIWindow?
}

extension AppDelegate: TrustDeviceInfoDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          // IQKeyboardManager Initialization
          IQKeyboardManager.shared.enable = true
          
          // MARK: - Audit
          setTrustAudit()

          // MARK: - Identify
          setTrustIdentify()
          
          // MARK: - Notifications
          firebaseConfig()
          registerForRemoteNotifications()
          
          setInitialVC()
          
          return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("URL: \(url)")
        
        saveOAuth2URLParametersFrom(url: url)
        OAuth2ClientHandler.shared.handleRedirectURL(url)

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        clearBadgeNumber()
        
        guard let mainVC = application.topMostViewController() as? MainScreenViewController else { return }
        let oAuth2Manager = OAuth2Manager()
        oAuth2Manager.managerOutput = self
        oAuth2Manager.silentAuthorize(from: mainVC)
    }
}

// MARK: - Set TrustID and Audit Access data
extension AppDelegate {
    func setTrustAudit() {
        TrustAudit.shared.set(serviceName: serviceName, accessGroup: accessGroup)
        TrustAudit.shared.set(currentEnvironment: .prod)
        TrustAudit.shared.createAuditClientCredentials(clientID: clientID, clientSecret: clientSecret)
    }
    
    func setTrustIdentify() {
        Identify.shared.trustDeviceInfoDelegate = self
        Identify.shared.set(serviceName: serviceName, accessGroup: accessGroup)
        Identify.shared.set(currentEnvironment: .prod)
        Identify.shared.createClientCredentials(clientID: clientID, clientSecret: clientSecret)
        Identify.shared.enable()
    }
    
    func onClientCredentialsSaved(savedClientCredentials: ClientCredentials) {
        guard let tokenType = savedClientCredentials.tokenType,
            let accessToken = savedClientCredentials.accessToken else { return }

        KeychainWrapper.standard.set("\(tokenType) \(accessToken)", forKey: "bearerToken")
    }
    
    func onTrustIDSaved(savedTrustID: String) {
        KeychainWrapper.standard.set("\(savedTrustID)", forKey: "trustID")

        // First SetAppState in first open
        Identify.shared.setAppState(dni: "", bundleID: "trust.noti-vixonic")
    }
    
    func onRegisterFirebaseTokenSuccess(responseData: RegisterFirebaseTokenResponse) {
        print("Firebase register token response: ", responseData)
    }
    
    func onSendDeviceInfoResponse(status: ResponseStatus) {
        //
    }
}

// MARK: - Notifications - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    //MARK: Initial Settings
    private func firebaseConfig() {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self
    }

    public func registerForRemoteNotifications(){
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            self.initLocationPermissions()
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    public func clearBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    // MARK: Background Notification
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.notifications.getNotification(response: response)

            completionHandler()
        }
    }

    // MARK: Foreground Notification
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        notifications.getNotificationForeground(notification: notification)

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(notification.request.content.userInfo)

        completionHandler([.alert, .badge, .sound])
    }
}

//MARK: Messaging Delegate
extension AppDelegate: MessagingDelegate{
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")

        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

        guard let bundle = Bundle.main.bundleIdentifier else{
            print("Bundle ID Error")
            return
        }
        Identify.shared.registerFirebaseToken(firebaseToken: fcmToken, bundleID: bundle)
    }
}

// MARK: - OAuth2ManagerOutputProtocol
extension AppDelegate: OAuth2ManagerOutputProtocol {
    func onAuthorizeSuccess() {}
    
    func onAuthorizeFailure(with errorMessage: String) {}
    
    func onSilentAuthorizeSuccess() {}
     
    func onSilentAuthorizeFailure() {}
}

// MARK: - setInitialVC
extension AppDelegate {
    private func setInitialVC() {
        let splashVC = SplashRouter.createModule()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navController = UINavigationController(rootViewController: splashVC)
        
        navController.setNavigationBarHidden(true, animated: false)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}

// MARK: - OAuth2 Methods
extension AppDelegate {
    private func saveOAuth2URLParametersFrom(url: URL) {
        guard
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryComponents = urlComponents.queryItems else {
                return
        }
        
        queryComponents.forEach {
            guard
                let key = UserDefaults.OAuth2URLData.StringDefaultKey(rawValue: $0.name),
                let value =  $0.value else {
                    return
            }
            
            UserDefaults.OAuth2URLData.set(value, forKey: key)
        }
    }
}

// MARK: - CLLocationManagerDelegate - UBICATION - Listener location permission response
extension AppDelegate: CLLocationManagerDelegate {
    func initLocationPermissions() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
    }
}
