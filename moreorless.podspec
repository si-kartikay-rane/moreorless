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
    s.dependency 'GamesLib/CompetitionFonts'
    # needed for mobilde adds:
    s.dependency 'Google-Mobile-Ads-SDK'
    s.dependency 'Kingfisher'
    s.dependency 'lottie-ios'
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
    #  s.subspec 'uwclmoreorless' do |uwcl|
    #  uwcl.resource_bundles = {
    #     'uwclmoreorless' => ['moreorless/Assets/themes/uwclmoreorless/**/*.{xcassets,xib,storyboard,strings,png,json}']
    #  }
    #  end
    #
    #  s.subspec 'uclmoreorless' do |ucl|
    #  ucl.resource_bundles = {
    #     'uclmoreorless' => ['moreorless/Assets/themes/uclmoreorless/**/*.{xcassets,xib,storyboard,strings,png,json}']
    #  }
    #  end
    #
    #  s.subspec 'euromoreorless' do |euro|
    #         euro.resource_bundles = {
    #     'euromoreorless' => ['moreorless/Assets/themes/euromoreorless/**/*.{xcassets,xib,storyboard,strings,png,json}']
    #  }
    #  end
    #
    #  s.subspec 'weuromoreorless' do |weuro|
    #         weuro.resource_bundles = {
    #     'weuromoreorless' => ['moreorless/Assets/themes/weuromoreorless/**/*.{xcassets,xib,storyboard,strings,png,json}']
    #  }
    #  end
    
    s.subspec 'uwclmoreorless' do |uwcl|
        uwcl.resource_bundles = {
            'uwclmoreorless' => ['moreorless/Assets/themes/uwclmoreorless/**/*.{xcassets,xib,storyboard,strings,png,json}']
        }
    end
    
    s.subspec 'uclmoreorless' do |ucl|
        ucl.resource_bundles = {
            'uclmoreorless' => ['moreorless/Assets/themes/uclmoreorless/**/*.{xcassets,xib,storyboard,strings,png,json}']
        }
    end
    
    s.subspec 'euromoreorless' do |euro|
        euro.resource_bundles = {
            'euromoreorless' => ['moreorless/Assets/themes/euromoreorless/**/*.{xcassets,xib,storyboard,strings,png,json}']
        }
    end
    
    s.subspec 'weuromoreorless' do |weuro|
        weuro.resource_bundles = {
            'weuromoreorless' => ['moreorless/Assets/themes/weuromoreorless/**/*.{xcassets,xib,storyboard,strings,png,json}']
        }
    end
end
