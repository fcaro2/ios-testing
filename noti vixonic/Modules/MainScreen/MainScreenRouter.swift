//
//  MainScreenRouter.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit

protocol MainScreenRouterDelegate: AnyObject {
    func onMainScreenDismissed()
}

// MARK: - Router
class MainScreenRouter: MainScreenRouterProtocol {
    var viewController: UIViewController?
    var delegate: MainScreenRouterDelegate?
    
    static func createModule() -> MainScreenViewController {
        
        let view = MainScreenViewController.storyboardViewController()
        let interactor: MainScreenInteractorProtocol & PermissionsManagerOutputProtocol = MainScreenInteractor()
        let presenter: MainScreenPresenterProtocol & MainScreenInteractorOutput = MainScreenPresenter()
        let router = MainScreenRouter()
        
        let userDataManager = UserDataManager()
        let auditDataManager = AuditDataManager()
        let permissionsManager = PermissionsManager()
        
        permissionsManager.managerOutput = interactor
        
        view.presenter = presenter

        interactor.interactorOutput = presenter
        
        interactor.userDataManager = userDataManager
        interactor.auditDataManager = auditDataManager
        interactor.permissionsManager = permissionsManager
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        router.viewController = view
        
        return view
    }
    
    func goToMainScreen() {
        viewController?.dismiss(animated: true)
    }
    
    func presentAlertView(with message: String, acceptAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        viewController?.presentAlertView(
            type: .customMessage(message: message),
            acceptAction: acceptAction,
            cancelAction: cancelAction
        )
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true) {
            [weak self] in
            
            guard let self = self else {
                return
            }
            
            self.delegate?.onMainScreenDismissed()
        }
    }
}
