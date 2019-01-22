#
# Be sure to run `pod lib lint ATRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ATRouter'
  s.version          = '0.9.0'
  s.summary          = 'ABCReading common Router'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    ABCReading common view controller Router.
                       DESC

  s.homepage         = 'https://github.com/ABCReading/ATRouter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ABCReading' => '2397172648@qq.com' }
  s.source           = { :git => 'https://github.com/ABCReading/ATRouter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ATRouter/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ATRouter' => ['ATRouter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'libextobjc', '0.4.1'
  # s.dependency 'Objection', '1.6.1'
  # s.dependency 'JLRoutes', '2.0.5'

end
