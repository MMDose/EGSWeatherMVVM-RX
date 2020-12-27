# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EGSTaskWeather' do
  use_frameworks!

    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxReachability'
    pod 'Nuke'
    
    target 'EGSTaskWeatherTests' do
        pod 'RxBlocking'
        pod 'RxTest'
    end

end


post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
end
