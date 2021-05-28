Pod::Spec.new do |spec|

  spec.name         = "Platform"
  spec.version      = "1.0.0"
  spec.summary      = "Components platform"
  spec.description  = "GithubUser"

  spec.homepage     = 'https://api.github.com'
  spec.license      = "MIT"
  spec.author       = "Nop"
  spec.platform     = :ios, "12.0"
  spec.source       = { :path => '.', :tag => "#{spec.version.to_s}" }
  
  spec.source_files = "Platform/**/*", "Platform/**/**/*.swift"

  spec.dependency "RxSwift"
  spec.dependency "Domain", '1.0.0'
  spec.dependency "Networking", '1.0.0'

end
