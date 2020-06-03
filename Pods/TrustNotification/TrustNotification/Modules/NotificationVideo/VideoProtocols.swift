//
//  VideoProtocols.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 03-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

protocol VideoViewProtocol: UIViewController {
    var data: NotificationInfo? {get set}
    
    func fillVideo()
    //func setViewState(state: LoadingStatus)
    func setBackground(color: backgroundColor)
    func setVideo()
    func setActionButtons(buttons: [Button])
}

protocol VideoInteractorProtocol: AnyObject {
    var interactorOutput: VideoInteractorOutputProtocol? {get set}
    var callbackDataManager: CallbackDataManagerProtocol? {get set}
    
    func onUserPerformAction(data: NotificationInfo, action: String)
    func onShowNotificationError()
}

protocol VideoInteractorOutputProtocol: AnyObject {
    func onCallbackSuccess()
    func onCallbackFailure()
}

protocol VideoPresenterProtocol: AnyObject {
    var view: VideoViewProtocol? {get set}
    var interactor: VideoInteractorProtocol? {get set}
    var router: VideoRouterProtocol? {get set}

    func onPersistenceButtonPressed()
    func onCloseButtonPressed()
    func onActionButtonPressed(action: String)
}

protocol VideoRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    
    static func createModule() -> VideoViewController
    
    func dismiss()
    func onActionButtonPressed()
}
