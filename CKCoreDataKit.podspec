Pod::Spec.new do |spec|
  spec.name       = 'CKCoreDataKit'
  spec.version    = '0.5.1'
  spec.license    = 'MIT'
  spec.summary    = 'CoreData syntax wrapper written in Swift'
  spec.homepage   = 'https://github.com/xmkevinchen/CKCoreDataKit'
  spec.authors    = { 'Kevin Chen' => 'xmkevinchen@gmail.com' }
  spec.license    = { :type => 'MIT', :file => 'LICENSE.md' }
  spec.source     = { :git => 'https://github.com/xmkevinchen/CKCoreDataKit.git',
                      :branch => :develop }

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'

  spec.source_files = 'CKCoreDataKit/**/*.swift'
  spec.requires_arc = true
  spec.frameworks   = 'CoreData'

end
