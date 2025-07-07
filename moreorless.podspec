#
# Be sure to run `pod lib lint moreorless.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'moreorless'
  s.version          = '0.1.0'
  s.summary          = 'A short description of moreorless.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/si-kartikay-rane/moreorless'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'si-kartikay-rane' => 'kartikay.rane@sportzinteractive.net' }
  s.source           = { :git => 'https://github.com/si-kartikay-rane/moreorless.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.5'

  s.static_framework = true

  s.source_files = 'moreorless/Classes/**/*'
  
  s.resource_bundles = {
    'moreorless' => ['moreorless/Assets/*.{xcassets,xib,storyboard,strings}']
  }

  s.dependency 'GamesLib/Native'
 # needed for mobilde adds:
 s.dependency 'Google-Mobile-Ads-SDK'
 
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
