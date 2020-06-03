//
//  TrustAudit.swift
//  TrustAudit
//
//  Created by Kevin Torres on 8/14/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Alamofire
import CoreTelephony
import RealmSwift

// MARK: - AuditDelegate
public protocol AuditDelegate: AnyObject {
    func onCreateAuditResponse()
    func onCreateAuditSuccess(responseData: CreateAuditResponse)
    func onCreateAuditFailure()
}

// MARK: - TrustAudit
public class TrustAudit {
    // MARK: - APIManager
    private lazy var apiManager: APIManagerProtocol = {
        let apiManager = APIManager()
        apiManager.managerOutput = self
        return apiManager
    }()
    
    // MARK: - Delegates
    public weak var auditDelegate: AuditDelegate?
    
    public var sendDeviceInfoCompletionHandler: ((ResponseStatusT) -> Void)?
    
    // MARK: - Private Init
    private init() {}
    
    static var trustID: String {
        return UserDefaults.standard.string(forKey: "trustID") ?? "ERROR"
    }
    
    private static var trustAudit: TrustAudit = {
        return TrustAudit()
    }()
    
    // MARK: - Shared instance
    public static var shared: TrustAudit {
        return trustAudit
    }
    
    private static var credentials: String?
    
    static var currentEnvironment: String {
        return UserDefaults.standard.string(forKey: "currentEnvironment") ?? "prod"
    }
    
    // MARK: - Shared keychain values
    static var accessGroup: String {
        return UserDefaults.standard.string(forKey: "accessGroup") ?? ""
    }
    
    static var serviceName: String {
        return UserDefaults.standard.string(forKey: "serviceName") ?? Bundle.main.bundleIdentifier ?? "SwiftKeychainWrapper"
    }
}

public enum Environment: String {
    case prod
    case test
}

// MARK: - Public Methods
extension TrustAudit {
    public func set(serviceName: String, accessGroup: String) {
        UserDefaults.standard.set(serviceName, forKey: "serviceName")
        UserDefaults.standard.set(accessGroup, forKey: "accessGroup")
    }
    
    public func set(currentEnvironment: Environment) {
        UserDefaults.standard.set(currentEnvironment.rawValue, forKey: "currentEnvironment")
    }
    
    public func getCurrentEnvironment() -> String {
        return UserDefaults.standard.string(forKey: "currentEnvironment") ?? "Check Lib"
    }
    
    public func createAuditClientCredentials(clientID: String , clientSecret: String) {
        let parameters = AuditClientCredentialsParameters(clientID: clientID, clientSecret: clientSecret)
        
        apiManager.getClientCredentials(with: parameters)
    }
    
    public func setTrustID(trustID: String){
        UserDefaults.standard.set(trustID, forKey: "trustID")
    }
    
    public func createAudit(trustID: String, connectionType: String, connectionName: String, type: String, result: String, method: String, operation: String) {
        
        let auditParameters = createParameters(
            trustID: trustID,
            connectionType: connectionType,
            connectionName: connectionName,
            type: type,
            result: result,
            method: method,
            operation: operation
        )
        
        saveAudit(auditParameters: auditParameters)
        apiManager.createAudit(with: auditParameters)
        
        print("Audit Parameters: \(auditParameters)")
    }
    
    // MARK: - Audit management
    func checkAuditEnqueue() -> Bool{
        print("Check audit enqueue count: \(getAll().count)")
        return getAll().count >= 1 ? true : false
    }
    
    func sendAuditEnqueue() { //Create audit
        guard let firstAuditInQueue = getFirstItem() else { return }
        apiManager.createAudit(with: firstAuditInQueue)
    }
    
    func deleteAuditById(currentLocalID: String) {
        guard let item = RealmRepo<CreateAuditParameters>.getBy(key: "localID", value: currentLocalID) else { return }
        RealmRepo<CreateAuditParameters>.delete(item: item)
    }
    
    public func saveAudit(auditParameters: CreateAuditParameters) {
        RealmRepo<CreateAuditParameters>.add(item: auditParameters)
    }
    
    func getAll() -> Results<CreateAuditParameters> {
        return RealmRepo<CreateAuditParameters>.getAll()
    }
    
    func getFirstItem() -> CreateAuditParameters? {
        return RealmRepo<CreateAuditParameters>.getFirst()
    }
    
    // MARK: - Generate Audit Parameters
    public func createParameters(trustID: String, connectionType: String, connectionName: String, type: String, result: String, method: String, operation: String) -> CreateAuditParameters {
        let auditParameters = CreateAuditParameters() //instance
        
        let sourceParameters = createSourceParameters(trustID: trustID, connectionType: connectionType, connectionName: connectionName)
        let transactionParameters = createTransactionParameters(type: type, result: result, method: method, operation: operation)
        let locationParameters = createLocationParameters()

        // BODY
        auditParameters.localID = UUID().uuidString
        auditParameters.auditType = "trust identify"
        auditParameters.platform = SourceDataManager.getOS() ?? ""
        auditParameters.application = SourceDataManager.getAppName() ?? ""
        auditParameters.source = sourceParameters
        auditParameters.transaction = transactionParameters
        auditParameters.location = locationParameters

        return auditParameters
    }
    
    // MARK : - Function create location parameters
    private func createLocationParameters() -> Location {
        let locationParameters = Location()
        
        let location = BodyDataManager()
        let auditLatitude = String(location.getLat())
        let auditLongitude = String(location.getLng())
        
        locationParameters.latitude = auditLatitude
        locationParameters.longitude = auditLongitude
        
        return locationParameters
    }
    
    // MARK : - Function create source parameters
    private func createSourceParameters(trustID: String, connectionType: String, connectionName: String) -> Source {
        let sourceParameters = Source()
        
        sourceParameters.trustID = trustID
        sourceParameters.appName =  SourceDataManager.getAppName() ?? ""
        sourceParameters.bundleID = SourceDataManager.getBundleID() ?? ""
        sourceParameters.connectionType = connectionType
        sourceParameters.connectionName = connectionName
        sourceParameters.appVersion = SourceDataManager.getAppVersion() ?? ""
        sourceParameters.os = SourceDataManager.getOS() ?? ""
        sourceParameters.deviceName = SourceDataManager.getDeviceName() ?? ""
        sourceParameters.osVersion = SourceDataManager.getOSVersion() ?? ""
        
        return sourceParameters
    }
    
    // MARK : - Function create transaction parameters
    private func createTransactionParameters(type: String, result: String, method: String, operation: String) -> Transaction {
        let transactionParameters = Transaction()
        
        transactionParameters.type = type
        transactionParameters.result = result
        transactionParameters.timestamp = TransactionDataManager.getTimestamp() ?? 1
        transactionParameters.method = method
        transactionParameters.operation = operation
        
        
        return transactionParameters
    }
}

// MARK: - APIManagerOutputProtocol
extension TrustAudit: APIManagerOutputProtocol {
    func onClientCredentialsResponse() {}
    
    func onClientCredentialsSuccess(responseData: AuditClientCredentials) {
        //TODO
    }
    
    func onClientCredentialsFailure() {}
    
    func onCreateAuditResponse() {
        auditDelegate?.onCreateAuditResponse()
    }
    
    func onCreateAuditSuccess(responseData: CreateAuditResponse, parameters: CreateAuditParameters) {
        auditDelegate?.onCreateAuditSuccess(responseData: responseData)
        if responseData.message != nil {
            deleteAuditById(currentLocalID: parameters.localID)
            if checkAuditEnqueue() {
                sendAuditEnqueue()
            } else {
                print("Done")
            }
        }
    }
    
    func onCreateAuditFailure() {
        auditDelegate?.onCreateAuditFailure()
    }
}
