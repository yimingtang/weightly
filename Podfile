platform :ios, '10.0'
inhibit_all_warnings!

target 'Weightly' do
    # Line graph
    pod 'BEMSimpleLineGraph'
    
    # Make auto layout easier
    pod 'Masonry'
    
    # A collection of useful Foundation and UIKit categories.
    pod 'SAMCategories'
    
    # Eliminate your Core Data boilerplate code
    pod 'SSDataKit'
end

target 'Weightly Today' do
    # Eliminate your Core Data boilerplate code
    pod 'SSDataKit'
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-Weightly/Pods-Weightly-acknowledgements.plist', 'Weightly/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
