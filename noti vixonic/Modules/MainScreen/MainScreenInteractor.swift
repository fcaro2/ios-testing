//
//  MainScreenInteractor.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import RealmSwift
import TrustDeviceInfo
import Audit

// MARK: - Interactor
class MainScreenInteractor: MainScreenInteractorProtocol {
    
    weak var interactorOutput: MainScreenInteractorOutput?
    
    var userDataManager: UserDataManagerProtocol?
    var auditDataManager: AuditDataManagerProtocol?
    
    var permissionsManager: PermissionsManagerProtocol?
    
    let generatedTrustId = Identify.shared.getTrustID()

    func openSettings() {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func checkBothPermissions() {
        permissionsManager?.checkBothPermissions()
    }
    
    func performLogout() {
        guard let profileDataSource = userDataManager?.getUser() else { return }
        
        interactorOutput?.onLogoutPerformed(item: profileDataSource)
    }

    func getProfileDataSource() {
        let profileDataSource = userDataManager?.getUser()
        
        interactorOutput?.onGetProfileDataSourceOutput(datasource: profileDataSource)
    }
    
    func getTrustIdDataSource() {
        interactorOutput?.onGetTrustIdDataSourceOutPut(trustId: generatedTrustId)
    }
    
    func cleanData(item: Object) {
        OAuth2ClientHandler.shared.forgetTokens()
        
        let realm = try! Realm()
        
        try! realm.write {
            
            realm.delete(item)
            interactorOutput?.onCleanedData()
        }
    }
    
    // MARK: - Login Audit
    func loginAudit() {
        auditDataManager?.createLoginAudit()
    }
}

// MARK: - PermissionsManagerOutputProtocol
extension MainScreenInteractor: PermissionsManagerOutputProtocol {
    func permissionsSuccess() {
        print("Permissions Success")
    }
    
    func permissionsFail() {
        interactorOutput?.showMessage()
    }
}

extension MainScreenInteractor: TrustDeviceInfoDelegate {
    func onClientCredentialsSaved(savedClientCredentials: ClientCredentials) {
//        Identify.shared.setAppState(dni: "", bundleID: "trust.noti-vixonic")
    }
    
    func onTrustIDSaved(savedTrustID: String) {
        //
    }
    
    func onRegisterFirebaseTokenSuccess(responseData: RegisterFirebaseTokenResponse) {
        //
    }
    
    func onSendDeviceInfoResponse(status: ResponseStatus) {
        //
    }
    
    func callSetAppState(profileDataSource: ProfileDataSource?) {
        let serviceName = "defaultServiceName"
        let accessGroup = "P896AB2AMC.trustID.appLib"
        let clientID = "adcc11078bee4ba2d7880a48c4bed02758a5f5328276b08fa14493306f1e9efb"
        let clientSecret = "1f647aab37f4a7d7a0da408015437e7a963daca43da06a7789608c319c2930bd"
        
        Identify.shared.set(serviceName: serviceName, accessGroup: accessGroup)
        Identify.shared.createClientCredentials(clientID: clientID, clientSecret: clientSecret)
        
        guard let rut = profileDataSource?.userDni else {
            return
        }

        guard let userName = profileDataSource?.name else {
            return
        }
        
        guard let lastName = profileDataSource?.lastName else {
            return
        }
        
        Identify.shared.setAppState(dni: rut, bundleID: "trust.noti-vixonic")
        
        var userIdentity = userDeviceInfo(dni: rut)
        userIdentity.name = userName
        userIdentity.lastname = lastName
        userIdentity.email = ""
        userIdentity.phone = ""
        
        Identify.shared.sendDeviceInfo(identityInfo: userIdentity)
    }
}

struct userDeviceInfo: IdentityInfoDataSource {
    var dni: String
    
    var name: String?
    
    var lastname: String?
    
    var email: String?
    
    var phone: String?
    
}
