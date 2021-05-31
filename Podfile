# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

  swift_version = "5.0"
  platform :ios, '12.0'

target 'Movity' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Movity
  pod 'RxNetworkApiClient', :inhibit_warnings => true
  pod 'RxSwift', '~> 5.0.1'
  pod 'SwiftyJSON', :inhibit_warnings => true
  pod 'DITranquillity', :inhibit_warnings => true
  pod 'R.swift', :inhibit_warnings => true
  pod "DBDebugToolkit", :inhibit_warnings => true
  pod 'Kingfisher', :inhibit_warnings => true
  pod 'MaterialTextField', :inhibit_warnings => true
  pod 'SOPullUpView', :inhibit_warnings => true
  pod 'YandexMapsMobile', '4.0.0-full'
  pod 'Alamofire'
  pod 'UBottomSheet'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'ProgressHUD'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
          config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
      end
    end
  end
end
