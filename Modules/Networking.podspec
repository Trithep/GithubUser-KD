
Pod::Spec.new do |spec|

  spec.name         = "Networking"
  spec.version      = "1.0.0"
  spec.summary      = "Networking module"
  spec.description  = "GithubUser"

  spec.homepage     = 'https://api.github.com'
  spec.license      = "MIT"
  spec.author       = "Nop"
  spec.platform     = :ios, "13.0"
  spec.source       = { :path => '.', :tag => "#{spec.version.to_s}" }
  spec.source_files  = "Networking/*.swift"
  
  spec.dependency "RxSwift"
  spec.dependency "RxCocoa"
  
end
