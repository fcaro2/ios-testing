//
//  CallbackDataManager.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 03-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Alamofire

protocol CallbackDataManagerProtocol: AnyObject {
    func receptionConfirmation(data: NotificationInfo, action: String, state: String, errorMessage: String?)
    func callback(data: NotificationInfo, action: String)

}

protocol CallbackDataManagerOuputProtocol: AnyObject {
    func onReceptionConfirmationSuccess()
    func onReceptionConfirmationFailure()
    func onCallbackSuccess()
    func onCallbackFailure()
}

class CallbackDataManager: CallbackDataManagerProtocol {
    
    var managerOutput: CallbackDataManagerOuputProtocol?
    
    func receptionConfirmation(data: NotificationInfo, action: String, state: String, errorMessage: String?) {
        let parameters = CallbackParameters(
            messageID: data.messageID,
            action: (data.type ?? "") + state,
            status: "2",
            trustID: data.trustID,
            errorMessage: errorMessage ?? "",
            type: data.type ?? "",
            actionButton: ""
        )
        
        API.call (
            responseDataType: CallbackResponse.self,
            resource: .confirmMessage(parameters: parameters),
            onSuccess: {
                [weak self] response in guard let self = self else { return }
                guard (response.code != 200) else {
                    print(response.data)
                    self.managerOutput?.onReceptionConfirmationSuccess()
                    return
                }
                print(response.code)
                self.managerOutput?.onCallbackFailure()
            }, onFailure: {
                [weak self] in
                guard let self = self else {
                    return
                }
                self.managerOutput?.onCallbackFailure()
            }
        )
    }
    
    func callback(data: NotificationInfo, action: String) {
        let parameters = CallbackParameters(
            messageID: data.messageID,
            action: (data.type ?? "dialog_legacy") + "_success",
            status: "2",
            trustID: data.trustID,
            errorMessage: "",
            type: data.type ?? "dialog_legacy",
            actionButton: action
        )
        
        API.call (
            responseDataType: CallbackResponse.self,
            resource: .confirmMessage(parameters: parameters),
            onSuccess: {
                [weak self] response in guard let self = self else { return }
                guard (response.code != 200) else {
                    print(response.data)
                    self.managerOutput?.onCallbackSuccess()
                    return
                }
                print(response.code)
                self.managerOutput?.onCallbackFailure()
            }, onFailure: {
                [weak self] in
                guard let self = self else {
                    return
                }
                self.managerOutput?.onCallbackFailure()
            }
        )
    }
}
