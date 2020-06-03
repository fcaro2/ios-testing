//
//  SplashProtocols.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - View
protocol SplashViewProtocol: AnyObject {}

// MARK: - Interactor
protocol SplashInteractorProtocol: AnyObject {
    var interactorOutput: SplashInteractorOutputProtocol? {get set}
    
    var oauth2Manager: OAuth2ManagerProtocol? {get set}
    var userDataManager: UserDataManagerProtocol? {get set}
    var locationDataManager: LocationManagerProtocol? {get set}
    
    func checkIfUserHasLoggedIn() //Get User, Check AccessToken
    func authorize(from context: AnyObject)
        
    func cleanData()
}

// MARK: - InteractorOutput
protocol SplashInteractorOutputProtocol: AnyObject {
    func onUserHasLoggedInSuccess()
    func onUserHasLoggedInFailure()
    
    func onAuthorizeSuccess()
    func onAuthorizeFailure()
    
    func returnViewDidAppear()
    
    func onGetAllPermissionsAccepted()
    
    func onDataCleaned()
}

// MARK: - Presenter
protocol SplashPresenterProtocol: AnyObject {
    var view: SplashViewProtocol? {get set}
    var router: SplashRouterProtocol? {get set}
    var interactor: SplashInteractorProtocol? {get set}

    func onViewDidAppear()
}

// MARK: - Router
protocol SplashRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    
    static func createModule() -> SplashViewController
    func goToMainScreen()
    func goToSessionMenuScreen()
}
