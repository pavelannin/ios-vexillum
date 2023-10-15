Pod::Spec.new do |s|
    s.name = 'Vexillum'
    s.version = '0.1.1'
    s.summary = 'Swift package for managing feature flags.'
    s.homepage = 'https://github.com/pavelannin/ios-vexillum'
    s.license = { :type => 'MIT License', :file => 'LICENSE' }
    s.author = { 'Pavel Annin' => 'pavelannin.dev@gmail.com' }
    s.source = { :git => 'https://github.com/pavelannin/ios-vexillum.git', :tag => s.version }
    s.source_files = 'Sources/**/*.swift'
    s.ios.deployment_target  = '13.0'
    s.osx.deployment_target = '10.15'
    s.watchos.deployment_target = '6.0'
    s.tvos.deployment_target = '13.0'
    s.framework = "Combine"
    s.swift_version = "5.9"
end
