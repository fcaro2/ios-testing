//
//  MainTabBarRouter.swift
//  coronapp
//
//  Created by ismael alvarez on 12-04-20.
//  Copyright © 2020 ismael alvarez. All rights reserved.
//

import UIKit
import MaterialComponents


class MainTabBarRouter: MainTabBarRouterProtocol {

    
    weak var tabBarController: UITabBarController?
    
    static func createModule() -> MainTabBarViewController {
        
        let view = MainTabBarViewController.storyboardViewController()
        let interactor: MainTabBarInteractorProtocol = MainTabBarInteractor()
        let presenter: MainTabBarPresenterProtocol & MainTabBarInteractorOutputProtocol = MainTabBarPresenter()
        let router: MainTabBarRouterProtocol = MainTabBarRouter()
        
        
        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.interactorOutput = presenter
        
        
        router.tabBarController = view
        
        
        return view
    }
}

extension MainTabBarRouter {
    
    func setViewControllers() {

        var viewControllers = [
            NotificationViewController.storyboardViewController(),
            MainScreenRouter.createModule()
        ]
        
        viewControllers = viewControllers.map {
            let nc = UINavigationController(rootViewController: $0)
            return nc
        }
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }
}
