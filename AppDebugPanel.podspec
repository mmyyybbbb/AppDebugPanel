Pod::Spec.new do |s|
  s.name             = 'AppDebugPanel' 
  s.version          = '1.2.5'
  s.summary          = 'Админка для тестирования приложения'
  s.homepage         = 'https://github.com/BCS-Broker/AppDebugPanel'
  s.author           = 'BCS'
  s.source           = { :git => 'https://github.com/BCS-Broker/AppDebugPanel.git', :tag => s.version.to_s }
  s.license      = { :type => 'MIT', :file => "LICENSE" }
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.module_name  = 'AppDebugPanel'
  s.source_files  = 'AppDebugPanel/**/*.{swift,storyboard}' 
  s.dependency 'netfox', '~> 1.19.0'
end
