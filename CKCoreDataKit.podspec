Pod::Spec.new do |spec|
  spec.name       = 'CKCoreDataKit'
  spec.version    = '0.5.2'
  spec.license    = 'MIT'
  spec.summary    = 'CoreData syntax wrapper written in Swift'
  spec.homepage   = 'https://github.com/xmkevinchen/CKCoreDataKit'
  spec.authors    = { 'Kevin Chen' => 'xmkevinchen@gmail.com' }
  spec.license    = { :type => 'MIT', :file => 'LICENSE.md' }
  spec.source     = { :git => 'https://github.com/xmkevinchen/CKCoreDataKit.git',
                      :tag => '0.5.2' }

  spec.ios.deployment_target = '8.0'
  # spec.osx.deployment_target = '10.9'

  spec.source_files = 'CKCoreDataKit/CKCoreDataKit.h', 'CKCoreDataKit/**/*.{h,m,swift}'
  spec.public_header_files = ['CKCoreDataKit/CKCoreDataKit.h']
  spec.requires_arc = true
  spec.frameworks   = 'CoreData'
  spec.dependency "CocoaLumberjack/Swift"

end
