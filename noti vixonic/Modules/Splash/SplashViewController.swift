//
//  SplashViewController.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit
import TrustNotification

class SplashViewController: UIViewController {
    var presenter: SplashPresenterProtocol?
}

// MARK: - Lifecycle
extension SplashViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.onViewDidAppear()
    }
}

// MARK: - View
extension SplashViewController: SplashViewProtocol {}

