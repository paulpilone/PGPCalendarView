#
# Be sure to run `pod lib lint PGPCalendarView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PGPCalendarView"
  s.version          = "0.1.1"
  s.summary          = "PGPCalendarView is calendar control that provides weekly, multi-week, and monthly views."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC 
                        PGPCalendarView is a nifty calendar control that provides a weekly, multi-week, and monthly view. 
                        You can display up to 10 calendar markers for specific dates by implementing the appropriate 
                        data source and delegate methods. The appearance is highly customizable and supports different 
                        week start days.
                       DESC
  s.homepage         = "https://github.com/paulpilone/PGPCalendarView"
  s.license          = 'MIT'
  s.author           = { "Paul Pilone" => "paul@element84.com" }
  s.source           = { :git => "https://github.com/paulpilone/PGPCalendarView.git", :tag => s.version.to_s }
  
  ##########
  # Platform

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.10'
  
  #######
  # Files
  
  s.ios.source_files = 'Pod/Classes/*.{h,m}', 'Pod/Classes/ios/*{.h,.m}'
  s.ios.resource_bundles = {
    'PGPCalendarView' => ['Pod/Assets/*.png', 'Pod/Assets/*.xib', 'Pod/Assets/ios/*.png', 'Pod/Assets/ios/*.xib']
  }

  s.osx.source_files = 'Pod/Classes/*.{h,m}', 'Pod/Classes/osx/*{.h,.m}'
  s.osx.resource_bundles = {
    'PGPCalendarView' => ['Pod/Assets/*.png', 'Pod/Assets/*.xib', 'Pod/Assets/osx/*.png', 'Pod/Assets/osx/*.xib']
  }

end
