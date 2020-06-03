//
//  DialogPresenter.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 03-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

class DialogPresenter: DialogPresenterProtocol{
    
    var view: DialogViewProtocol?
    var interactor: DialogInteractorProtocol?
    var router: DialogRouterProtocol?
    
    func verifyImageURL(imageUrl: String) {
         //Set the dialog image
        if(verifyUrl(urlString: imageUrl)){
            let imageUrl = URL(string: imageUrl)!
            view?.setImage(image: imageUrl)
        }else{
            //to do
        }
    }
    
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

extension DialogPresenter: DialogInteractorOutputProtocol{
    func onCallbackSuccess() {
        router?.dismiss()
    }
    
    func onCallbackFailure() {
        //to do
    }

}
