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
    case alert(AlertViewModel)
    case actionSheet(AlertViewModel)
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
            
        case let .actionSheet(viewModel):
            
            let vc = UIAlertController(title: viewModel.output.title, message: viewModel.output.message, preferredStyle: UIAlertController.Style.actionSheet)
            
            if let title = viewModel.output.leftTitle {
                
                let action = UIAlertAction(title: title, style: .default, handler: { (_) in
                    viewModel.input.action.accept(AlertAction.left)
                })
                
                vc.addAction(action)
            }
            
            if let title = viewModel.output.rightTitle {
                let action = UIAlertAction(title: title, style: .destructive, handler: { (_) in
                    viewModel.input.action.accept(AlertAction.right)
                })
                
                vc.addAction(action)
            }
            
            
            let action = UIAlertAction(title: "ยกเลิก", style: .cancel, handler: { (_) in
                viewModel.input.action.accept(AlertAction.none)
            })
            
            vc.addAction(action)
            
            
            return vc
            
        case let .alert(viewModel):
            
            let vc = UIAlertController(title: viewModel.output.title, message: viewModel.output.message, preferredStyle: UIAlertController.Style.alert)
            
            if let title = viewModel.output.leftTitle {
                
                let action = UIAlertAction(title: title, style: .cancel, handler: { (_) in
                    viewModel.input.action.accept(AlertAction.left)
                })

                vc.addAction(action)
                
                if viewModel.output.boldAction == .left {
                     vc.preferredAction = action
                }
            }
            
            if let title = viewModel.output.rightTitle {
                let action = UIAlertAction(title: title, style: .default, handler: { (_) in
                    viewModel.input.action.accept(AlertAction.right)
                })
                
                vc.addAction(action)
                
                if viewModel.output.boldAction == .right {
                     vc.preferredAction = action
                }
                
            }
            
            return vc
        }
    }
}
