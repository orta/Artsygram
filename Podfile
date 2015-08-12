source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/artsy/Specs.git'

platform :ios, '8.0'
inhibit_all_warnings!

# Artsy
pod 'Artsy+UILabels'
pod 'Artsy+UIColors'
pod 'UIView+BooleanAnimations'
pod 'AFNetworking'

if %w(orta ash artsy laura eloy sarahscott).include?(ENV['USER']) || ENV['CI'] == 'true'
  pod 'Artsy+UIFonts', '1.0.0'
else
  pod 'Artsy+OSSUIFonts'
end

# Nicities
pod 'ObjectiveSugar', :git => 'https://github.com/supermarin/ObjectiveSugar'
pod 'APLArrayDataSource'
