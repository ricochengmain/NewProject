platform :ios, '15.0'
use_frameworks!
inhibit_all_warnings!

# 添加所有的 target
targetsArray = [
  'NewProject',
]

targetsArray.each do |t|
  target t do
  pod 'SnapKit'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['OTHER_CFLAGS'] = '$(inherited) -w'
    end
  end
end
