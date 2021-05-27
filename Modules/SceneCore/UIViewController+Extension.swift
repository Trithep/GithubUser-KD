//
//  UIViewController+Extension.swift
//  
import UIKit

public extension UIViewController {
    
    static func tabController(window: UIWindow) -> UIViewController? {
        
        guard let rootViewController = window.rootViewController else {
            return nil
        }
        
        return self.tabControllerWithRootViewController(rootViewController: rootViewController)
    }
    
    static func tabControllerWithRootViewController(rootViewController: UIViewController?) -> UIViewController? {
        if rootViewController is UITabBarController {
            return rootViewController
            
        } else if let navigationController = rootViewController as? UINavigationController {
            if navigationController.viewControllers.first is UITabBarController {
                return navigationController.viewControllers.first
            }

            if navigationController.topViewController is UITabBarController {
                return navigationController.topViewController
            }
            
            return self.tabControllerWithRootViewController(rootViewController: navigationController.visibleViewController)
            
        } else if let control = rootViewController?.presentedViewController {
            return self.tabControllerWithRootViewController(rootViewController: control)
        }
        
        return rootViewController
    }
    
    static func topViewController(window: UIWindow) -> UIViewController? {
        
        guard let rootViewController = window.rootViewController else {
            return nil
        }
        
        return self.topViewController(rootViewController: rootViewController)
    }
    
    static func topViewController(rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        switch rootViewController {
        case let navigationController as UINavigationController:
            return topViewController(rootViewController: navigationController.viewControllers.last)
            
        case let tabBarController as UITabBarController:
            return topViewController(rootViewController: tabBarController.selectedViewController)
            
        default:
            break
        }
        
        guard let presented = rootViewController.presentedViewController else {
            return rootViewController
        }
        
        switch presented {
        case let navigationController as UINavigationController:
            return topViewController(rootViewController: navigationController.viewControllers.last)
            
        case let tabBarController as UITabBarController:
            return topViewController(rootViewController: tabBarController.selectedViewController)
            
        default:
            return topViewController(rootViewController: presented)
        }
    }
    
    static func getViewController(root: UIViewController, type: UIViewController.Type) -> UIViewController? {
        
        if root.classForCoder == type {
            return root
        } else if let nav = root as? UINavigationController, let vc = nav.viewControllers.first(where: {$0.classForCoder == type}) {
            return vc
        } else if let tab = root as? UITabBarController, let vc = tab.viewControllers?.first(where: {$0.classForCoder == type}) {
            return vc
        } else if let vc = root.presentedViewController {
            return getViewController(root: vc, type: type)
        } else {
            return nil
        }
    }
    
}
