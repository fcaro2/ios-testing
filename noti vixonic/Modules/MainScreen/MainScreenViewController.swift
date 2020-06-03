//
//  MainScreenViewController.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit
import MaterialComponents
import TrustDeviceInfo

// MARK: ProfileDataSource
protocol ProfileDataSource {
    var completeName: String? {get}
    var name: String? {get}
    var lastName: String? {get}
    var userDni: String? {get}
    var userPhone: String? {get}
    var userEmail: String? {get}
}

class MainScreenViewController: UIViewController {
    @IBAction func testError(_ sender: Any) {
        Identify.shared.setAppState(dni: "", bundleID: "trust.noti-vixonic")
    }
    
    
    @IBOutlet weak var phoneStackView: UIStackView!
    @IBOutlet weak var dniStackView: UIStackView!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var trustIDStackView: UIStackView!
    
    var presenter: MainScreenPresenterProtocol?
    @IBOutlet weak var dniLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var trustIdLabel: UILabel! {
        didSet {
            trustIdLabel.isUserInteractionEnabled = true
            let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
            trustIdLabel.addGestureRecognizer(guestureRecognizer)
        }
    }
    
    // MARK: - Permission message
    @IBOutlet weak var permissionsMessage: UIView!
    @IBOutlet weak var permissionsBackground: UIView! {
        didSet {
            permissionsBackground?.backgroundColor = .blackBackground
        }
    }
    
    @IBOutlet weak var cancelMessageButton: MDCButton! {
        didSet {
            cancelMessageButton.setupButtonWithType(type: .btnVixonicBlackColor, mdcType: .text)
            cancelMessageButton.addTarget(
                self,
                action: #selector(onCancelMessageButtonPressed(sender:)),
                for: .touchUpInside
            )
        }
    }
    
    @IBOutlet weak var acceptMessageButton: MDCButton!{
        didSet {
            acceptMessageButton.setupButtonWithType(type: .btnVixonicColor, mdcType: .text)
            
            acceptMessageButton.addTarget(
                self,
                action: #selector(onAcceptMessageButtonPressed(sender:)),
                for: .touchUpInside
            )
        }
    }
        
    var profileDataSource: ProfileDataSource? {
        didSet {
            guard let dataSource = profileDataSource else { return }
            nameLabel.text = dataSource.completeName?.capitalized
            
            if let dni = dataSource.userDni {
                if dni != "" {
                    dniStackView.show()
                    let parsedDni = dni.parse()
                    dniLabel.text = parsedDni
                    Identify.shared.setAppState(dni: dni, bundleID: "trust.noti-vixonic")
                } else { dniStackView.hide() }
            } else { dniStackView.hide() }
            
            if let phone = dataSource.userPhone {
                if phone != "" {
                    phoneStackView.show()
                    phoneLabel.text = phone
                } else { phoneStackView.hide() }
            } else { phoneStackView.hide() }
            
            if let email = dataSource.userEmail {
                if email != "" {
                    emailStackView.show()
                    emailLabel.text = email
                } else { emailStackView.hide() }
            } else { emailStackView.hide() }
        }
    }
    
    @IBOutlet weak var logoutButton: MDCButton! {
        didSet {
            logoutButton.setupButtonWithType(type: .btnSecondary, mdcType: .contained)
            
            logoutButton.addTarget(
                self,
                action: #selector(onLogoutButtonPressed(sender:)),
                for: .touchUpInside
            )
        }
    }
}

// MARK: - MainScreenViewProtocol
extension MainScreenViewController: MainScreenViewProtocol {
    func set(profileDataSource: ProfileDataSource?) {
        self.profileDataSource = profileDataSource
    }
    
    func setTrustId(trustIdDataSource: String?) {
        trustIdLabel.text = trustIdDataSource
    }
    
    func showPermissionModal() {
        permissionsMessage.show()
        permissionsBackground.show()
    }
    
    func hidePermissionModal() {
        permissionsMessage.hide()
        permissionsBackground.hide()
    }
}

// MARK: - Buttons targets
extension MainScreenViewController {
    @objc func onLogoutButtonPressed(sender: UIButton) {
        self.presenter?.onLogoutButtonPressed()
    }
    
    @objc func onAcceptMessageButtonPressed(sender: UIButton) {
        self.presenter?.openVixonicSettings()
        self.hidePermissionModal()
    }
    
    @objc func onCancelMessageButtonPressed(sender: UIButton) {
        self.hidePermissionModal()
    }
}

// MARK: - Label Targets
extension MainScreenViewController {
    @objc func labelClicked(_ sender: Any) {
        UIPasteboard.general.string = trustIdLabel.text
    }
}

// MARK: - Lifecycle
extension MainScreenViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Cuenta"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }
}
