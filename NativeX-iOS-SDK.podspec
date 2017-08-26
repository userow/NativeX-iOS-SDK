#
# Be sure to run `pod lib lint NativeXiOSSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NativeX-iOS-SDK'
  s.version          = '5.5.9'
  s.summary          = 'NativeX-iOS-SDK '

  s.description      = <<-DESC
NativeX-iOS-SDK Ad SDK
                       DESC

  s.homepage         = 'https://github.com/userow/NativeX-iOS-SDK'
  s.license          = { :type => 'MIT', :file => 'LICENSES/' }
  s.author           = { 'userow' => 'userow@gmail.com' }
  s.source           = { :git => 'https://github.com/userow/NativeX-iOS-SDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.frameworks = 'AdSupport', 'CoreGraphics', 'Foundation', 'MediaPlayer', 'StoreKit', 'SystemConfiguration', 'UIKit'
  s.library   = 'sqlite3.0'

  s.vendored_frameworks = 'NativeXiOSSDK-5.5.9'

end
