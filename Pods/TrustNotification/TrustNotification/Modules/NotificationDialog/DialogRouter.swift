//
//  DialogRouter.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 03-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

class DialogRouter: DialogRouterProtocol{
    var viewController: UIViewController?
    
    static func createModule() -> DialogViewController {
        let view = DialogViewController.storyboardViewController()
        let presenter: DialogPresenterProtocol & DialogInteractorOutputProtocol = DialogPresenter()
        let interactor: DialogInteractorProtocol & CallbackDataManagerOuputProtocol = DialogInteractor()
        let router = DialogRouter()
        
        let callbackDataManager = CallbackDataManager()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.interactorOutput = presenter
        interactor.callbackDataManager = callbackDataManager
        
        router.viewController = view
        
        callbackDataManager.managerOutput = interactor
        
        
        return view
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
    
    func onActionButtonPressed() {
        //
    }
}
