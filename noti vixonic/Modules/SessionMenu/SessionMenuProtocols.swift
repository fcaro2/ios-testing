//
//  SessionMenuProtocols.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - View
protocol SessionMenuViewProtocol: AnyObject {
    func startActivityIndicator()
    func stopActivityIndicator()
}

// MARK: - Interactor
protocol SessionMenuInteractorProtocol: AnyObject {
    var interactorOutput: SessionMenuInteractorOutput? {get set}
    var oauth2Manager: OAuth2ManagerProtocol? {get set}
    var userDataManager: UserDataManagerProtocol? {get set}
    
    func authorizeUser(from context: AnyObject)
    func getUserProfile()
    func changeEnvironment(environment: String)
}

// MARK: - InteractorOutput
protocol SessionMenuInteractorOutput: AnyObject {
    func onAuthorizeSuccess()
    func onAuthorizeFailure(with errorMessage: String)
    
    func onGetUserProfileResponse()
    func onGetUserProfileSuccess()
    func onGetUserProfileFailure(with errorMessage: String)
    
    func onUserDataSaved()
    
    func onMissingInfoFromRetrievedProfile()
}

// MARK: - Presenter
protocol SessionMenuPresenterProtocol: AnyObject {
    var view: SessionMenuViewProtocol? {get set}
    var interactor: SessionMenuInteractorProtocol? {get set}
    var router: SessionMenuRouterProtocol? {get set}
    
    func onItrustHydraLoginButtonPressed(from context: AnyObject)
}

// MARK: - Router
protocol SessionMenuRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    static func createModule() -> SessionMenuViewController
    
    func goToMainScreen()
    func presentAlertView(with errorMessage: String)
}
