# Uncomment this line to define a global platform for your project
platform :ios, '8.3'
# Uncomment this line if you're using Swift
use_frameworks!

target 'MapTodo' do
	pod 'Firebase/Core'
	pod 'GoogleMaps'
	pod 'GooglePlaces'
	pod 'RealmSwift'
	pod 'R.swift'
	pod 'SwiftLint'
end

target 'MapTodoTests' do

end

target 'MapTodoUITests' do

end
post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-MapTodo/Pods-MapTodo-acknowledgements.plist', 'MapTodo/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
