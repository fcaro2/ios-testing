//
//  DialogProtocols.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 03-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

protocol DialogViewProtocol: UIViewController {
    var data: NotificationInfo? {get set}
    
    func fillDialog()
    func setBackground(color: backgroundColor)
    func setCloseButton(cancelable: Bool)
    func setPersistenceButton(persistence: Bool)
    func setImage(image: URL)
    func setBody(text: String)
    func setActionButtons(buttons: [Button])
}

protocol DialogInteractorProtocol: AnyObject {
    var interactorOutput: DialogInteractorOutputProtocol? {get set}
    var callbackDataManager: CallbackDataManagerProtocol? {get set}
    
    func onUserPerformAction(data: NotificationInfo, action: String)
    func onShowNotificationError()
}

protocol DialogInteractorOutputProtocol: AnyObject {
    func onCallbackSuccess()
    func onCallbackFailure()
}

protocol DialogPresenterProtocol: AnyObject {
    var view: DialogViewProtocol? {get set}
    var interactor: DialogInteractorProtocol? {get set}
    var router: DialogRouterProtocol? {get set}
    
    func verifyImageURL(imageUrl: String)
    func onPersistenceButtonPressed()
    func onCloseButtonPressed()
    func onActionButtonPressed(action: String)
}

protocol DialogRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    
    static func createModule() -> DialogViewController
    
    func dismiss()
    func onActionButtonPressed()
}
