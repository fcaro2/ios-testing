//
//  MainTabBarPresenter.swift
//  coronapp
//
//  Created by ismael alvarez on 12-04-20.
//  Copyright © 2020 ismael alvarez. All rights reserved.
//


// MARK: - MainTabBarPresenter
class MainTabBarPresenter: MainTabBarPresenterProtocol {
    weak var view: MainTabBarViewProtocol?
    var interactor: MainTabBarInteractorProtocol?
    var router: MainTabBarRouterProtocol?
}

// MARK: - View Lifecycle
extension MainTabBarPresenter {
    func onViewDidLoad() {
        
        router?.setViewControllers()

        view?.addBottomNavBarAsSubView()
    }
    
    func onViewWillLayoutSubviews() {
        view?.setBottomNavBarFrame()
    }
    
}

// MARK: - MainTabBarInteractorOutputProtocol
extension MainTabBarPresenter: MainTabBarInteractorOutputProtocol {}
