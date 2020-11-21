platform :ios, '13.0'

target 'stori' do
  use_frameworks!

  # Network and Caching
#  pod 'Alamofire'
#  pod 'AlamofireNetworkActivityLogger', :configurations => ['Debug']
#  pod 'SwiftyJSON'
#  pod 'Kingfisher'
  
  # Google
#  pod 'Firebase/Core'
#  pod 'Firebase/Analytics'
#  pod 'Firebase/Performance'
#  pod 'Firebase/Crashlytics'
#  pod 'Firebase/Firestore'
#  pod 'Google-Mobile-Ads-SDK'
  
  # System Functionality
#  pod 'SwiftyStoreKit'
  pod 'SwiftLint'
#  pod 'KeychainSwift'
#  pod 'ReachabilitySwift'
#  pod 'UITextView+Placeholder'
#  pod 'IQKeyboardManagerSwift'
  
  #UI Pods
  pod "UPCarouselFlowLayout"
#  pod 'SwiftMessages'
#  pod 'SideMenu'
#  pod 'SimpleCheckbox'
#  pod 'Cluster'
#  pod 'Cosmos'
#  pod 'Cards'
#  pod 'ImageSlideshow'
#  pod 'ImageSlideshow/Kingfisher'
#  pod 'youtube-ios-player-helper'
#  pod 'PhoneNumberKit'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
        config.build_settings['EXCLUDED_ARCHS[sdk=watchsimulator*]'] = 'arm64'
        config.build_settings['EXCLUDED_ARCHS[sdk=appletvsimulator*]'] = 'arm64'
      end
    end
  end
  
end
