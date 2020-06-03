//
//  SessionMenuPresenter.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import CoreLocation

// MARK: - Presenter
class SessionMenuPresenter: SessionMenuPresenterProtocol {
    weak var view: SessionMenuViewProtocol?
    var interactor: SessionMenuInteractorProtocol?
    var router: SessionMenuRouterProtocol?
    
    func onItrustHydraLoginButtonPressed(from context: AnyObject) {
        view?.startActivityIndicator()
        interactor?.authorizeUser(from: context)
    }
}

extension SessionMenuPresenter: SessionMenuInteractorOutput {
    func onAuthorizeSuccess() {
        interactor?.getUserProfile()
    }
    
    func onAuthorizeFailure(with errorMessage: String) {
        router?.presentAlertView(with: errorMessage)
        view?.stopActivityIndicator()
    }
    
    func onGetUserProfileResponse() {
        view?.stopActivityIndicator()
    }
    
    func onGetUserProfileSuccess() {
        router?.goToMainScreen()
    }
    
    func onGetUserProfileFailure(with errorMessage: String) {
        router?.presentAlertView(with: errorMessage)
    }
    
    func onUserDataSaved() {
        //TODO
    }
    
    func onMissingInfoFromRetrievedProfile() {
        //TODO
    }
}
