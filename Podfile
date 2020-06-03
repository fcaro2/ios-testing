  platform :ios, '12.1'
  
  source 'https://github.com/trusttechnologies/auditpodspecs.git'
  source 'https://github.com/trusttechnologies/TrustDeviceInfoPodSpecs.git'
  source 'https://github.com/trusttechnologies/trustnotificationpodspecs.git'
  source 'https://github.com/CocoaPods/Specs.git'

  use_frameworks!
target 'noti vixonic' do
  pod 'MaterialComponents'
  pod 'MaterialComponents/TextFields'
  pod 'MaterialComponents/Buttons', '~> 87.1.1'
  pod 'MaterialComponents/Buttons+ButtonThemer', '~> 87.1.1'
  pod 'MaterialComponents/Snackbar+TypographyThemer'
  pod 'MaterialComponents/BottomNavigation'
  pod 'MaterialComponents/BottomNavigation+TypographyThemer'
  pod 'MaterialComponents/BottomNavigation+ColorThemer'

  pod 'TrustDeviceInfo'
  pod 'Audit'
  pod 'TrustNotification'

  pod 'IQKeyboardManagerSwift'

  pod 'p2.OAuth2'
  pod 'lottie-ios'
  
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'

  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '4.3.1'
  pod 'Alamofire', '~> 4.8.1'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = ‘4.2’
      end
    end
    
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
end
