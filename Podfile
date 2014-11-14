source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'

# Line graph
pod 'BEMSimpleLineGraph'

# Make auto layout easier
pod 'Masonry'

# A collection of useful Foundation and UIKit categories.
pod 'SAMCategories'

# Eliminate your Core Data boilerplate code
pod 'SSDataKit'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
