//
//  SplashInteractor.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SplashInteractor: SplashInteractorProtocol {
    var interactorOutput: SplashInteractorOutputProtocol?
    
    var oauth2Manager: OAuth2ManagerProtocol?
    var userDataManager: UserDataManagerProtocol?
    var locationDataManager: LocationManagerProtocol?
        
    // MARK: - Checking user
    func checkIfUserHasLoggedIn() { // * 1 Get user -> 2 check access token
        guard userDataManager?.getUser() != nil else { // 1
            interactorOutput?.onUserHasLoggedInFailure() //Not user, clear data
            return
        }

        interactorOutput?.onUserHasLoggedInSuccess()
    }
    
    func authorize(from context: AnyObject) {
        oauth2Manager?.silentAuthorize(from: context)
    }
    
    func cleanData() {
        userDataManager?.deleteAll(completion: nil)
        oauth2Manager?.clearTokens() //
        
        let realm = try! Realm()

        try! realm.write {
            realm.deleteAll()
            
            interactorOutput?.onDataCleaned()
        }
    }
}

// MARK: - OAuth2ManagerOutputProtocol
extension SplashInteractor: OAuth2ManagerOutputProtocol {
    func onAuthorizeSuccess() {
        print("onAuthorizeSuccess")
    }
    
    func onAuthorizeFailure(with errorMessage: String) {
        print("onAuthorizeFailure")
    }
    
    func onSilentAuthorizeSuccess() {
        interactorOutput?.onAuthorizeSuccess()
    }
    
    func onSilentAuthorizeFailure() {
        interactorOutput?.onAuthorizeFailure()
    }
}

extension SplashInteractor: LocationManagerOutputProtocol {
    
    func requestNotificationFail() {
        //TODO
    }
    
    func requestLocationFail() {
        //TODO
    }
}
