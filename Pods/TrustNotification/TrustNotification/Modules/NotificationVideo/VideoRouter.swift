//
//  VideoRouter.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 03-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

class VideoRouter: VideoRouterProtocol{
    var viewController: UIViewController?
    
    static func createModule() -> VideoViewController {
        let view = VideoViewController.storyboardViewController()
        let presenter: VideoPresenterProtocol & VideoInteractorOutputProtocol = VideoPresenter()
        let interactor: VideoInteractorProtocol & CallbackDataManagerOuputProtocol = VideoInteractor()
        let router = VideoRouter()
        
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
