  

# Trust Technologies

![image](https://avatars2.githubusercontent.com/u/42399326?s=200&v=4)

# Description


Trust is a platform that allows building trust and security between people and technology.

Trust-Audit allows you to send custom or automatic audit per device.

# Implementation
Add in your podfile:

``` Swift
platform :ios, '12.1'
source 'https://github.com/trusttechnologies/auditpodspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
  

target 'NameApp' do

...

pod 'Audit'

...

end
```

And execute:

```

pod install

```
# Initialize
Set the following to your AppDelegate didFinishLaunchingWithOptions:
 ```swift
import TrustDeviceInfo

extension AppDelegate {
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

   	let serviceName = "defaultServiceName"
   	let accessGroup = "A2D9N3HN.trustID.example"
   	let clientID = "example890348h02758a5f8bee4ba2d7880a48d0581e9efb"
   	let clientSecret = "example8015437e7a963dacaa778961f647aa37f6730bd"

   	TrustAudit.shared.set(serviceName: serviceName, accessGroup: accessGroup)
		TrustAudit.shared.createAuditClientCredentials(clientID: clientID, clientSecret: clientSecret)

   	return  true
   }
}
```


To generate a new audit we need [activate](https://github.com/trusttechnologies/lat_trust_mobile_ios_audit_library#permissions) Access WiFi Information in Signing & Capabilities.

Once the [TrustID](https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-identify_library)  is created you can use the next login AuditDataManager example:



 ```swift
import Audit
import TrustDeviceInfo
import CoreTelephony
import SystemConfiguration.CaptiveNetwork

// MARK: - AuditDataManagerProtocol
protocol AuditDataManagerProtocol: NSObjectProtocol {
	func createLoginAudit()
}

// MARK: - AuditDataManager
class AuditDataManager: NSObject, AuditDataManagerProtocol {

	private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")

	func createLoginAudit() {
		guard let savedTrustId = Identify.shared.getTrustID() else { return }
		guard let connectionType = checkReachable() else { return }
		guard let ssidConnection = getWiFiSsid() else { return }

		TrustAudit.shared.createAudit(trustID: savedTrustId, connectionType: connectionType, connectionName: ssidConnection, type: "trust identify", result: "success", method: "createLoginAudit", operation: "login")
	}
}

// MARK: - Connection Data
extension  AuditDataManager {
	//Get connection type
	private func checkReachable() -> String? {
		var flags = SCNetworkReachabilityFlags()
		SCNetworkReachabilityGetFlags(self.reachability!, &flags)

		if (isNetworkReachable(with: flags)) {
		print(flags)
			if flags.contains(.isWWAN) {
				return "MOBILE"
			}
			else {
				return "WIFI"
			}
		}
		else if (!isNetworkReachable(with: flags)) {
			print("Sorry, No connection")
			print(flags)
			return  "DISCONNECTED"
		}
		return  "Error in connection data"
	}

	private  func  isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
		let isReachable = flags.contains(.reachable)
		let needsConnection = flags.contains(.connectionRequired)
		let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
		let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)

		return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
	}

	// Get internet ssid
	func getWiFiSsid() -> String? {
		var flags = SCNetworkReachabilityFlags()
		SCNetworkReachabilityGetFlags(self.reachability!, &flags)

		if (isNetworkReachable(with: flags)) {
			print(flags)
			if flags.contains(.isWWAN) {
				let networkInfo = CTTelephonyNetworkInfo()
				let carrierType = networkInfo.serviceCurrentRadioAccessTechnology
				if carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyLTE") }) != nil {
					print ("Wwan : 4G")
					return "4G"
				}
				else if carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyGPRS") }) != nil || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyEdge") }) != nil  || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyCDMA1x") }) != nil {
					print("Wwan : 2G")
					return "2G"
				}
			else if carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyWCDMA") }) != nil || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyHSDPA") }) != nil  || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyHSUPA") }) != nil || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyCDMAEVDORev0") }) != nil  || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyCDMAEVDORevA") }) != nil || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyCDMAEVDORevB") }) != nil || carrierType!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyeHRPD") }) != nil  {
				print ("Wwan : 3G")
				return "3G"
			}
		}
		else { //Return wifi connection name
			var ssid: String?
				if let interfaces = CNCopySupportedInterfaces() as NSArray? {
					for interface in interfaces {
						if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
							ssid = interfaceInfo[kCNNetworkInfoKeySSID 				as String] as? String
							break
						}
					}
				}
				return ssid
			}
		}
		else  if (!isNetworkReachable(with: flags)) { //No internet, return disconnected
			print("Sorry, No connection")
			print(flags)
			return  "DISCONNECTED"
		}
		return "UNKNOWN"
	}
}
```

# Permissions

To ensure the proper functioning of the audit library, in signing and Capabilities layer we must add the "Access WiFi Information" capability.

![Image](https://github.com/trusttechnologies/lat_trust_mobile_ios_audit_library/blob/master/Access%20WiFi%20Information.png?raw=true)

*NOTE: Remember to generate the TrustID with the [TrustDeviceInfo](https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-identify_library) library.*

To get location coordinates we need add in our "info.plist" the next lines.

![Image](https://github.com/trusttechnologies/lat_trust_mobile_ios_audit_library/blob/master/Location%20Permissions.png?raw=true)
