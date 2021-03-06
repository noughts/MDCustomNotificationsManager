Pod::Spec.new do |s|
  s.name             = "MDCustomNotificationsManager"
  s.version          = "0.9.0"
  s.summary          = "Display messages in a notification-like way"
  s.homepage         = "https://github.com/noughts/MDCustomNotificationsManager"
  s.screenshots      = "http://s14.postimg.org/ydle62d0f/MDCNM.gif"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Jorge Pardo" => "JorgePardoPeset@gmail.com" }
  s.source           = { :git => "https://github.com/noughts/MDCustomNotificationsManager.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Thecafremo'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'
  s.resources = 'Classes/**/*.{png,xib}'
  s.public_header_files = 'Classes/**/*.h'

end
