# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Complexity' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

   # Pods for Complexity
pod 'GooglePlaces'
pod 'GoogleMaps'
pod 'Kingfisher'
pod 'IQKeyboardManagerSwift', '6.3.0'
pod 'ReachabilitySwift'
pod 'IQAPIClient'
pod 'KeychainSwift', '~> 20.0'
pod 'SkeletonUI', :git => 'https://github.com/timdolenko/SkeletonUI.git', :branch => 'bug/iOS-17-CPU-Issue'
pod 'KeychainSwift', '~> 20.0'
pod  'ExpandableText'
end


post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
   config.build_settings['WATCHOS_DEPLOYMENT_TARGET'] = '6.0'
   end
  if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
   target.build_configurations.each do |config|
    config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
   end
  end
 end
end
