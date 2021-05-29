//
//  AppDelegate.swift
//  GithubUser
//
//  Created by Trithep Thumrongluck on 26/5/2564 BE.
//

import UIKit
import SceneCore
import Domain
import Platform
import Networking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: SceneCoordinator!
    var provider: Domain.UseCaseProviderDomain!
    var network: URLSessionNetwork!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.register(defaults: ["favorite_user" : []])
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        coordinator = .init(window: window)
        network = .init(base: URL(string: BaseURL.api)!)
        provider = UseCaseProvider(network: network)
       
        let viewModel = MainViewModel(coordinator: coordinator, provider: provider)
        let scene = MainScene.main(viewModel: viewModel)
        let vc = scene.viewController as! MainViewController
        let navigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

