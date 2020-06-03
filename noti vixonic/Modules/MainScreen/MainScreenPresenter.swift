//
//  MainScreenPresenter.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//
import RealmSwift

// MARK: - Presenter
class MainScreenPresenter: MainScreenPresenterProtocol {
    weak var view: MainScreenViewProtocol?
    var interactor: MainScreenInteractorProtocol?
    var router: MainScreenRouterProtocol?
    
    func onViewDidLoad() {
        interactor?.checkBothPermissions()
        interactor?.getProfileDataSource()
        interactor?.getTrustIdDataSource()
    }
    
    func onViewWillAppear() {
        interactor?.loginAudit()
    }
    
    func onLogoutButtonPressed() { //Start Logout
        interactor?.performLogout() //Use performLogout in MainScreenInteractor
    }
    
    func openVixonicSettings() {
        interactor?.openSettings()
    }
}

// MARK: - InteractorOutput
extension MainScreenPresenter: MainScreenInteractorOutput {
    func showMessage() {
        view?.showPermissionModal()
    }
    
    func onGetTrustIdDataSourceOutPut(trustId: String?) {
        view?.setTrustId(trustIdDataSource: trustId)
    }
    
    func onLogoutPerformed(item: Object) {
        interactor?.cleanData(item: item)
    }
    
    func onGetProfileDataSourceOutput(datasource: ProfileDataSource?) {
        view?.set(profileDataSource: datasource)
        interactor?.callSetAppState(profileDataSource: datasource)
    }
    
    func onCleanedData() {
        router?.goToMainScreen()
    }
}
