Pod::Spec.new do |s|
  s.name             = 'Vexillum'
  s.version          = '0.1.3'
  s.summary          = 'Feature toggling'
  s.description      = <<-DESC
                        Swift package for managing feature flags.
                        DESC
  s.homepage         = 'https://github.com/pavelannin/ios-vexillum'
  s.license          = 'MIT'
  s.author           = { 'Pavel Annin' => 'pavelannin.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/pavelannin/ios-vexillum.git', :tag => s.version.to_s }
  s.homepage         = 'https://github.com/pavelannin/ios-vexillum'

  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/Vexillum/*.swift'
  s.swift_versions = ['5.7', '5.8', '5.9']
end
