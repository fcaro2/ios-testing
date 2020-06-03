//
//  DialogInteractor.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 03-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

class DialogInteractor: DialogInteractorProtocol{
    var interactorOutput: DialogInteractorOutputProtocol?
    
    var callbackDataManager: CallbackDataManagerProtocol?
    
    func onUserPerformAction(data: NotificationInfo, action: String) {
        callbackDataManager?.callback(data: data, action: action)
        
    }
    func onShowNotificationError() {
        //
    }
    
}

extension DialogInteractor: CallbackDataManagerOuputProtocol{
    func onReceptionConfirmationSuccess() {
        //
    }
    
    func onReceptionConfirmationFailure() {
        //
    }
    
    func onCallbackSuccess() {
        interactorOutput?.onCallbackSuccess()
    }
    
    func onCallbackFailure() {
        //
    }

}
