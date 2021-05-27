# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

def default_pods
  
    pod 'Action'
    pod 'Kingfisher'
        #pod 'Moya/RxSwift'
        #pod 'Moya-ObjectMapper/RxSwift'
    pod 'MBProgressHUD'
    pod 'Reusable'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxOptional'
    pod 'SwiftLint'

end

def modules_pods
  pod 'Domain', :path => 'Modules'
  pod 'Platform', :path => 'Modules'
  pod 'Networking', :path => 'Modules'
end

target 'GithubUser' do
  
  use_frameworks!

  default_pods
  modules_pods

  target 'GithubUserTests' do
    inherit! :search_paths

  end

  target 'GithubUserUITests' do
   
  end

end
