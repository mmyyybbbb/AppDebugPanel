platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

def pods
  pod 'netfox', '~> 1.15.0'
end

target 'AppDebugPanel' do
  pods
end

target 'AppDebugPanelDemo' do
  pods
end 


post_install do |installer|
  
  installer.pods_project.targets.each do |target|
    
    if ['netfox'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
    
    
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
  end
  
end

