//
//  SessionMenuViewController.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import MaterialComponents
import UIKit
import Lottie

// MARK: - SessionMenuViewController
class SessionMenuViewController: UIViewController {
    
    var animationView = AnimationView()
    let filename = "vixonic-loader"
    
    @IBOutlet weak var activityIndicatorBackground: UIView!
    @IBOutlet weak var loadingView: LottieView!
    @IBOutlet weak var loadingBackground: UIView!

    @IBOutlet weak var loginButton: MDCButton! {
        didSet {
            loginButton.setupButtonWithType(type: .btnPrimary, mdcType: .contained)
    
            loginButton.addTarget(
                self,
                action: #selector(onLoginButtonPressed(sender:)),
                for: .touchUpInside
            )
        }
    }
    
    var presenter: SessionMenuPresenterProtocol?
}

// MARK: - SessionMenuViewProtocol
extension SessionMenuViewController: SessionMenuViewProtocol {
    func startActivityIndicator() {
        let secondsToDelay = 0.4
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) { //Delay animation
            let animation = Animation.named(self.filename)
            self.animationView.animation = animation
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.play(fromProgress: 0,
                               toProgress: 1,
                               loopMode: LottieLoopMode.loop,
                               completion: { (finished) in
                                if finished {
                                    print("Animation Complete")
                                } else {
                                    print("Animation cancelled")
                                }
            })
            self.animationView.translatesAutoresizingMaskIntoConstraints = false
            self.loadingView.addSubview(self.animationView)
            
            self.loadingBackground.backgroundColor = .white
            self.loadingView.backgroundColor = .white


            NSLayoutConstraint.activate([
                self.animationView.heightAnchor.constraint(equalTo: self.loadingView.heightAnchor),
                self.animationView.widthAnchor.constraint(equalTo: self.loadingView.widthAnchor),
            ])
            
            self.activityIndicatorBackground.show()
            self.loadingBackground.show()
            self.view.bringSubviewToFront(self.loadingView)
            self.animationView.backgroundBehavior = .pauseAndRestore
        }
    }
    
    func stopActivityIndicator() {
        self.animationView.stop()
        loadingBackground.hide()
        activityIndicatorBackground.hide()
    }
}

// MARK: - Buttons targets
extension SessionMenuViewController {
    @objc func onLoginButtonPressed(sender: UIButton) {
        presenter?.onItrustHydraLoginButtonPressed(from: self)
    }
}
