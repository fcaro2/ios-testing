//
//  SessionMenuRouter.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - Router
class SessionMenuRouter: SessionMenuRouterProtocol {
    var viewController: UIViewController?
    
    static func createModule() -> SessionMenuViewController {
        let view = SessionMenuViewController.storyboardViewController()
        let interactor: SessionMenuInteractor & OAuth2ManagerOutputProtocol = SessionMenuInteractor()
        let presenter: SessionMenuPresenterProtocol & SessionMenuInteractorOutput = SessionMenuPresenter()
        let router = SessionMenuRouter()
        
        let oauth2Manager = OAuth2Manager()
        let userDataManager = UserDataManager()
        
        view.presenter = presenter
        
        interactor.interactorOutput = presenter
        interactor.oauth2Manager = oauth2Manager
        interactor.userDataManager = userDataManager
        
        oauth2Manager.managerOutput = interactor
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        router.viewController = view
        
        return view
    }
    
    func goToMainScreen() {
        let mainScreenVC = MainTabBarRouter.createModule()
        
        viewController?.present(mainScreenVC, animated: true)
    }
    
    func presentAlertView(with errorMessage: String) {
        viewController?.presentAlertView(type: .customMessage(message: errorMessage))
    }
}
