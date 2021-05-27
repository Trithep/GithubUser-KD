
Pod::Spec.new do |spec|

  spec.name         = "Domain"
  spec.version      = "1.0.0"
  spec.summary      = "Components domain"
  spec.description  = "GithubUser"

  spec.homepage     = 'https://api.github.com'
  spec.license      = "MIT"
  spec.author       = "Nop"
  spec.platform     = :ios, "13.0"
  spec.source       = { :path => '.', :tag => "#{spec.version.to_s}" }
  
  spec.source_files = "Domain/**/*", "Domain/**/**/*.swift"

  spec.dependency "RxSwift"

end
