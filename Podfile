# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def default_pods
  
    pod 'Action'
    pod 'Kingfisher'
    pod 'MBProgressHUD'
    pod 'Reusable'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxOptional'
    pod 'RxDataSources'
    pod 'SwiftLint'
    pod 'Kingfisher'
    pod 'Reusable'
end

def modules_pods
  pod 'Domain', :path => 'Modules'
  pod 'Platform', :path => 'Modules'
  pod 'Networking', :path => 'Modules'
  pod 'SceneCore', :path => 'Modules'
  pod 'Extensions', :path => 'Modules'
end

target 'GithubUser' do
  
  use_frameworks!

  default_pods
  modules_pods

  target 'GithubUserTests' do
    inherit! :search_paths
    pod 'RxTest'
  end

  target 'GithubUserUITests' do
   
  end

end
