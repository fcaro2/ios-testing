//
//  LocationManager.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

// MARK: - LocationManagerProtocol
protocol LocationManagerProtocol: AnyObject {

}

protocol LocationManagerOutputProtocol {
    func requestNotificationFail()
    func requestLocationFail()
}

class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {
    static let shared = LocationManager()
    private var locationManager = CLLocationManager()
    private let operationQueue = OperationQueue()
    var managerOutput: LocationManagerOutputProtocol?

    override init(){
        super.init()
        operationQueue.isSuspended = true
        locationManager.delegate = self
    }

    ///User presses the allow/don't allow buttons on the popup dialogue
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //If we're authorized to use location services, run all operations in the queue
        //otherwise if we were denied access, cancel the operations
        if(status == .authorizedAlways || status == .authorizedWhenInUse){
            self.operationQueue.isSuspended = false
        }else if(status == .denied){
            
            self.managerOutput?.requestLocationFail()

            self.operationQueue.cancelAllOperations()
        }
    }

    ///Checks the status of the location permission
    /// and adds the callback block to the queue to run when finished checking
    /// NOTE: Anything done in the UI should be enclosed in `DispatchQueue.main.async {}`
    func runLocationBlock(callback: @escaping () -> ()){

        let authState = CLLocationManager.authorizationStatus()

        if(authState == .authorizedAlways || authState == .authorizedWhenInUse){
            self.operationQueue.isSuspended = false
        }else{
            locationManager.requestAlwaysAuthorization() //Request permission
        }
        
        let block = { callback() } //Create a closure with the callback function so we can add it to the operationQueue

        //Add block to the queue to be executed asynchronously
        self.operationQueue.addOperation(block)
    }
}
