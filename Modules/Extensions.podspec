

Pod::Spec.new do |spec|

  spec.name         = "Extensions"
  spec.version      = "1.0.0"
  spec.summary      = "components extension"
  spec.description  = "GithubUser"

  spec.homepage     = 'https://api.github.com'
  spec.license      = "MIT"
  spec.author       = "Nop"
  spec.platform     = :ios, "13.0"
  spec.source       = { :path => '.', :tag => "#{spec.version.to_s}" }
  
  spec.default_subspec = "All"
  

  spec.subspec 'All' do |ss|
    ss.source_files  = "Extensions/*", "Extensions/**/*.swift"
    ss.dependency 'MBProgressHUD'
  end

  spec.dependency "RxSwift"
  spec.dependency "RxCocoa"

end
