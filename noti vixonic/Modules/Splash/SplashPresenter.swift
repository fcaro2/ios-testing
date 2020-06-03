//
//  SplashPresenter.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class SplashPresenter: SplashPresenterProtocol {
    var view: SplashViewProtocol?
    
    var router: SplashRouterProtocol?
    
    var interactor: SplashInteractorProtocol?
    
    func onViewDidAppear() {
        interactor?.checkIfUserHasLoggedIn()
    }
}

// MARK: - InteractorOutput
extension SplashPresenter: SplashInteractorOutputProtocol {
    // MARK: - Splash login
    func onUserHasLoggedInSuccess() {
        if let context = router?.viewController {
            interactor?.authorize(from: context)
        }
    }
    
    func onUserHasLoggedInFailure() {
        interactor?.cleanData()
    }
    
    func onAuthorizeSuccess() {
        router?.goToMainScreen()
    }
    
    func onAuthorizeFailure() {
        router?.goToSessionMenuScreen()
    }
    
    func onDataCleaned() {
        router?.goToSessionMenuScreen()
    }
    
    func returnViewDidAppear() {
        self.onViewDidAppear()
    }
    
    func onGetAllPermissionsAccepted() {
        interactor?.checkIfUserHasLoggedIn()
    }
}
