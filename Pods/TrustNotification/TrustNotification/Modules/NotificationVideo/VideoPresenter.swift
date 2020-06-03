//
//  VideoPresenter.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 03-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

class VideoPresenter: VideoPresenterProtocol{
    
    var view: VideoViewProtocol?
    var interactor: VideoInteractorProtocol?
    var router: VideoRouterProtocol?
    
    func onPersistenceButtonPressed() {
        interactor?.onUserPerformAction(data: view!.data!, action: "close")
    }
    
    func onCloseButtonPressed() {
        interactor?.onUserPerformAction(data: view!.data!, action: "close")
    }
    
    func onActionButtonPressed(action: String) {
        if let url = URL(string: action) {
            UIApplication.shared.open(url , options: [:], completionHandler: nil)
            interactor?.onUserPerformAction(data: view!.data!, action: action)
        }
    }
    
}

extension VideoPresenter: VideoInteractorOutputProtocol{
    func onCallbackSuccess() {
        router?.dismiss()
    }
    
    func onCallbackFailure() {
        //to do
    }

}
