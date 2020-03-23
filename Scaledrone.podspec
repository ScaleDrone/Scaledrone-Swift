Pod::Spec.new do |s|
  s.name             = 'Scaledrone'
  s.version          = '0.5.2'
  s.summary          = 'Scaledrone Swift Client'
  s.homepage         = 'https://github.com/scaledrone/scaledrone-swift'
  s.license          = 'Apache-2.0'
  s.author           = { "Scaledrone" => "info@scaledrone.com" }
  s.requires_arc     = true
  s.source           = { git: "https://github.com/scaledrone/Scaledrone-Swift.git", :tag => "0.5.1" }
  s.swift_version    = '5.0'
  
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Scaledrone/Classes/**/*'
  s.dependency "Starscream", "~> 3.1.0"
  
end
