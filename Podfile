source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/artsy/Specs.git'

platform :ios, '8.0'
inhibit_all_warnings!

# Artsy
pod 'Artsy+UILabels'
pod 'Artsy+UIColors'
pod 'UIView+BooleanAnimations'

plugin 'cocoapods-keys', {
    :project => "Artsy",
    :keys => [
    "ArtsyAPI2ClientSecret",
    "ArtsyAPI2ClientKey",
    ]
}

if %w(orta ash artsy laura eloy sarahscott).include?(ENV['USER']) || ENV['CI'] == 'true'
  pod 'Artsy+UIFonts', '1.0.0'
else
  pod 'Artsy+OSSUIFonts'
end

# Nicities
pod 'ObjectiveSugar', git: 'https://github.com/supermarin/ObjectiveSugar'
pod 'APLArrayDataSource'
pod 'AFWebViewController', '~> 1.0'

pod 'AFNetworking'
pod "Artsy+Authentication", git: "https://github.com/artsy/Artsy_Authentication", branch: "no_twitter"
