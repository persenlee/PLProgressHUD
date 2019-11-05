Pod::Spec.new do |s|

  s.name         = "PLProgressHUD"
  s.version      = "1.0.0"
  s.summary      = "PLProgressHUD is a Simple loading & progress HUD written by swift"

  s.description  = <<-DESC
                   support internel style and custom support
                   DESC

  s.homepage     = "https://github.com/persenlee/PLProgressHUD"
  s.screenshots  = "https://raw.githubusercontent.com/persenlee/PLProgressHUD/master/images/logo.png"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.authors            = { "persenlee" => "persenlee@gmail.com" }
  s.social_media_url   = "https://twitter.com/persenlee"

  s.swift_version = "5.1"
  s.swift_versions = ['4.0', '4.2', '5.0','5.1']

  s.ios.deployment_target = "10.0"

  s.source       = { :git => "https://github.com/persenlee/PLProgressHUD.git", :tag => s.version }

  s.source_files  = "Sources/PLProgressHUD/*"


  s.requires_arc = true


end
