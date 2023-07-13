#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint share.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'dl_share_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
社会化分享,支持钉钉和微信分享
                       DESC
  s.homepage         = 'https://www.shdatalink.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.vendored_frameworks = 'Framework/*.framework'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.dependency 'WechatOpenSDK-XCFramework'

  s.static_framework = true

  s.frameworks = ["SystemConfiguration", "CoreTelephony","WebKit"]
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES',
  'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64',
  'OTHER_LDFLAGS'                         => '$(inherited) -ObjC -all_load',
}
end
