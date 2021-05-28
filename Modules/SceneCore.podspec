
Pod::Spec.new do |spec|

  spec.name         = "SceneCore"
  spec.version      = "1.0.0"
  spec.summary      = "Core classes for main application and every modules"
  spec.description  = "GithubUser"

  spec.homepage     = 'https://api.github.com'
  spec.license      = "MIT"
  spec.author       = "Nop"
  spec.platform     = :ios, "12.0"
  spec.source       = { :path => ".", :tag => "#{spec.version.to_s}" }
  spec.source_files = "SceneCore/*.swift"
  spec.exclude_files = "SceneCore/Info.plist"
  
  spec.dependency "RxSwift"
  spec.dependency "RxCocoa"
  spec.dependency "Domain", '1.0.0'
end
