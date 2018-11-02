Pod::Spec.new do |s|
  s.name             = 'Scaledrone'
  s.version          = '0.4.0'
  s.summary          = 'Scaledrone Swift Client'
  s.homepage         = 'https://github.com/scaledrone/scaledrone-swift'
  s.license          = 'MIT'
  s.author           = { "Scaledrone" => "info@scaledrone.com" }
  s.source           = { git: "https://github.com/ScaleDrone/Scaledrone-Swift.git" }
  s.requires_arc = true
  s.source_files = 'scaledrone-swift/Scaledrone.swift'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'

  s.dependency "Starscream", "~> 2.1.0"
end
