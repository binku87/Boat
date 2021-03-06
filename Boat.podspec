#
# Be sure to run `pod lib lint Boat.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Boat"
  s.version          = "0.1.1"
  s.summary          = "Boat: A library to draw something"
  s.description      = <<-DESC
                        A library to draw something.
                        A library to draw something.
                       DESC
  s.homepage         = "https://github.com/binku87/Boat"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "binku" => "binku87@gmail.com" }
  s.source           = { :git => "https://github.com/binku87/Boat.git", :tag => "0.1.1" }
  # s.social_media_url = 'https://twitter.com/binku87'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'Boat' => ['Pod/Assets/*.png']
  }

  #s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '1.3.3'
  s.dependency 'AFNetworking-Synchronous', '0.2.0'
  s.dependency 'SDWebImage', '3.7.1'
  s.dependency 'FMDBMigrationManager', '1.3.1'
  s.dependency 'LKDBHelper', '2.1'
  s.dependency 'UIImage+animatedGif', '0.1.0'
end
