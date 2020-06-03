//
//  MainTabBarViewProtocol.swift
//  coronapp
//
//  Created by ismael alvarez on 12-04-20.
//  Copyright © 2020 ismael alvarez. All rights reserved.
//

import UIKit


// MARK: - View
protocol MainTabBarViewProtocol: AnyObject {
    var presenter: MainTabBarPresenterProtocol? { get set }

    func addBottomNavBarAsSubView()
    func setBottomNavBarFrame()
}

// MARK: - Interactor
protocol MainTabBarInteractorProtocol: AnyObject {
    var interactorOutput: MainTabBarInteractorOutputProtocol? { get set }
}

// MARK: - Interactor Output
protocol MainTabBarInteractorOutputProtocol: AnyObject {}

// MARK: - Presenter
protocol MainTabBarPresenterProtocol: AnyObject {
    var view: MainTabBarViewProtocol? { get set }
    var interactor: MainTabBarInteractorProtocol? { get set }
    var router: MainTabBarRouterProtocol? { get set }
    
    func onViewDidLoad()
    func onViewWillLayoutSubviews()
}

// MARK: - Router
protocol MainTabBarRouterProtocol: AnyObject {
    var tabBarController: UITabBarController? { get set }
    static func createModule() -> MainTabBarViewController

    func setViewControllers()
}
