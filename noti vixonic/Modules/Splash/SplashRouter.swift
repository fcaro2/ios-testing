//
//  SplashRouter.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - Router
class SplashRouter: SplashRouterProtocol {
    
    var viewController: UIViewController?
    static func createModule() -> SplashViewController {
        let view = SplashViewController.storyboardViewController()
        let interactor: SplashInteractorProtocol & OAuth2ManagerOutputProtocol & LocationManagerOutputProtocol = SplashInteractor()
        let presenter: SplashPresenterProtocol & SplashInteractorOutputProtocol = SplashPresenter()
        let router = SplashRouter()

        let oauth2Manager = OAuth2Manager()
        let userDataManager = UserDataManager()
        let locationManager = LocationManager()
        
        view.presenter = presenter

        interactor.interactorOutput = presenter
        interactor.oauth2Manager = oauth2Manager
        interactor.locationDataManager = locationManager
        interactor.userDataManager = userDataManager

        oauth2Manager.managerOutput = interactor
        locationManager.managerOutput = interactor

        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor

        router.viewController = view
        
        return view
    }
    
    func goToMainScreen() {
        let mainScreenVC = MainScreenRouter.createModule()
        
        viewController?.present(mainScreenVC, animated: true)
        
//        viewController?.navigationController?.setViewControllers([mainScreenVC], animated: true)
    }
    
    func goToSessionMenuScreen() {
        DispatchQueue.main.async {
            let sessionMenuScreenVC = SessionMenuRouter.createModule()
            
            self.viewController?.present(sessionMenuScreenVC, animated: true)
        }
        
//        viewController?.navigationController?.setViewControllers([sessionMenuScreenVC], animated: true)
    }
}
