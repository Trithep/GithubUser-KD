//
//  Scene.swift
//  
import UIKit

public protocol Scene {
    var viewController: UIViewController { get }
}

public protocol SceneView {
    var view: UIView { get }
}

public enum BasicScene {
    case navigationMultipleVC(with: [Scene],_ isHiddenNavigationBar: Bool)
    case navigation(Scene,_ isHiddenNavigationBar: Bool)
    case debugInput((String) -> ())
}

extension BasicScene: Scene {
    public var viewController: UIViewController {
        
        switch self {
            
        case let .navigationMultipleVC(scenes, isHide):
            let nav = UINavigationController()
            let vcs = scenes.map {$0.viewController}
            nav.setViewControllers(vcs, animated: false)
            nav.isNavigationBarHidden = isHide
            return nav
            
        case let .navigation(scene, isHide):
            let rootViewController = scene.viewController
            let nav = UINavigationController(rootViewController: rootViewController)
            nav.isNavigationBarHidden = isHide
            return nav
        case let .debugInput(callBack):
            
            let alert = UIAlertController(title: "Debug", message: "Point", preferredStyle: .alert)
            alert.addTextField { (_) in
                
            }
            
            let ok = UIAlertAction.init(title: "OK", style: .default) { (_) in
                callBack(alert.textFields?.first?.text ?? "")
            }
            
            alert.addAction(ok)
            return alert
        }
    }
}
