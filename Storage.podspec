Pod::Spec.new do |s|
  s.name             = "Storage"
  s.summary          = "A short description of Storage."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/zenangst/Storage"
  s.license          = 'MIT'
  s.author           = { "zenangst" => "chris@zenangst.com" }
  s.source           = { :git => "https://github.com/zenangst/Storage.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zenangst'
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Source/**/*'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
