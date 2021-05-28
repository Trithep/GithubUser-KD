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
        network = .init(base: URL(string: "https://api.github.com")!)
        provider = UseCaseProvider(network: network)
       
        let viewModel = MainViewModel(coordinator: coordinator, provider: provider)
        let scene = MainScene.main(viewModel: viewModel)
       
        self.window?.rootViewController = scene.viewController as! MainViewController
        self.window?.makeKeyAndVisible()

        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

