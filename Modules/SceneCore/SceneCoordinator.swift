//
//  SceneCoordinator.swift
// 

import UIKit
import RxSwift
import RxCocoa
import Domain

public protocol SceneCoordinatorType {
    
    var hasNavigation: Bool { get }
    var isFirstSceneInNavigationStack: Bool { get }
    
    func transition(type: SceneTransition)
    func transitionWithRx(type: SceneTransition) -> Observable<Void>
}

open class SceneCoordinator: SceneCoordinatorType {
    
    private let HOST_VIEW_TAG = 999
    
    public weak var window: UIWindow?
    public var checkMemberScene: Scene?
    
    public init(window: UIWindow?) {
        self.window = window
    }
    
    public func isShowAlert() -> Bool {
        guard let window = window else { return false }
        return UIViewController.topViewController(window: window) is UIAlertController
    }
    
    
    public var hasNavigation: Bool {
        
        guard let rootVC = window?.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
            return false
        }
        
        return topVC.navigationController != nil
        
    }
    
    public var isFirstSceneInNavigationStack: Bool {
        guard let rootVC = window?.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                   return false
               }
               
        return (topVC.navigationController?.viewControllers.count ?? 0) == 1
    }
    
    
    public func transition(type: SceneTransition) {
        transitionWithRx(type: type)
    }

    @discardableResult
    open func transitionWithRx(type: SceneTransition) -> Observable<Void> {
        
        guard let window = window else { return Observable.just(()) }
        
        let isFinish = BehaviorRelay(value: false)
        
        DispatchQueue.main.async {
            
            switch type {
                
            case .open(let url):
                
                let app = UIApplication.shared
                guard app.canOpenURL(url) else {
                    print("Cannot open url ~> \(url)")
                    break
                }
                if #available(iOS 10.0, *) {
                    app.open(url, options: [:], completionHandler: nil)
                    isFinish.accept(true)
                } else {
                    app.openURL(url)
                    isFinish.accept(false)
                }
                break

            case let .root(scene, _):
                
                let vc = scene.viewController
                window.rootViewController = vc
                window.makeKeyAndVisible()
                
            case let .modal(scene, animated):
                
                guard let rootVC = window.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                    fatalError()
                }
                
                let vc = scene.viewController
                vc.modalPresentationStyle = .fullScreen
                topVC.present(vc, animated: animated) {
                    isFinish.accept(true)
                }
                
                break
                
            case let .modalWithCompletion(scene, animated, completion):
                
                guard let rootVC = window.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                    fatalError()
                }
                
                let vc = scene.viewController
                vc.modalPresentationStyle = .fullScreen
                topVC.present(vc, animated: animated) {
                    completion()
                    isFinish.accept(true)
                }
                
                break
            
            case let .modalOver(scene, animated):
                
                guard let rootVC = window.rootViewController,
                    let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                    fatalError()
                }
                
                let vc = scene.viewController
                vc.definesPresentationContext = true
                vc.providesPresentationContextTransitionStyle = true
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                topVC.present(vc, animated: animated) {
                    isFinish.accept(true)
                }
                
                break
                
            case let .customModal(scene, animated):
                
                guard let rootVC = window.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                    fatalError()
                }
                
                let vc = scene.viewController
                vc.modalPresentationStyle = .custom
                topVC.present(vc, animated: animated) {
                    isFinish.accept(true)
                }
                
                break
                
            case let .modalTab(scene, animated):
                
                guard let tab = UIViewController.tabController(window: window) as? UITabBarController else {
                    fatalError("tabs view controller not found")
                }
                
                let vc = scene.viewController
                vc.modalPresentationStyle = .fullScreen
                tab.view.endEditing(true)
                tab.present(vc, animated: animated) {
                    isFinish.accept(true)
                }
                
            case let .cardModal(scene, animated):
                
                guard let rootVC = window.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                    fatalError()
                }
                
                let vc = scene.viewController
                vc.modalPresentationStyle = .pageSheet
                
                topVC.view.endEditing(true)
                topVC.present(vc, animated: animated) {
                    isFinish.accept(true)
                }
                
            case let .dismiss(animated):
                
                guard let rootVC = window.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                    fatalError()
                }
                
                topVC.dismiss(animated: animated) {
                    isFinish.accept(true)
                }
                
                break
            case let .dismissWithCompletion(animated, completion):
                
                guard let rootVC = window.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                    fatalError()
                }
                
                topVC.dismiss(animated: animated) {
                    completion()
                    isFinish.accept(true)
                }
                
            case let .dismissFrom(type, animated, completion):
                
                guard let rootVC = window.rootViewController else {
                    fatalError()
                }
                if let vc = UIViewController.getViewController(root: rootVC, type: type) {
                   
                    vc.dismiss(animated: animated) {
                        completion?()
                        isFinish.accept(true)
                    }
                    
                } else {
                    completion?()
                    isFinish.accept(true)
                }

            case let .dismissToRootWithCompletion(animated, completion):
                
                guard let rootVC = window.rootViewController else {
                    fatalError()
                }
                
                rootVC.dismiss(animated: animated) {
                    completion?()
                    isFinish.accept(true)
                }
                
            case let .push(scene, animated):
                
                guard let rootVC = window.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                    fatalError()
                }
                
                let vc = scene.viewController
                topVC.navigationController?.pushViewController(vc, animated: animated)
                isFinish.accept(true)
                
                break
            case let .pop(animated):
                
                guard let rootVC = window.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                    fatalError()
                }
                
                topVC.navigationController?.popViewController(animated: animated)
                isFinish.accept(true)
                
                break
                
            case let .popTo(type, animated):
                
                guard let rootVC = window.rootViewController, let topVC = UIViewController.getViewController(root: rootVC, type: type) else {
                    fatalError()
                }
                
                topVC.navigationController?.popToViewController(topVC, animated: animated)
                isFinish.accept(true)
                
                break
            
            case let .popToRoot(animated):
                
                guard let rootVC = window.rootViewController, let topVC = UIViewController.topViewController(rootViewController: rootVC) else {
                    fatalError()
                }
                
                topVC.navigationController?.popToRootViewController(animated: animated)
                
                isFinish.accept(true)
                
                break
            case let .modalView(sceneView, animated):
                
                let stateContainerView = UIView()
                stateContainerView.tag = self.HOST_VIEW_TAG
                stateContainerView.alpha = 0
                
                stateContainerView.translatesAutoresizingMaskIntoConstraints = false
                
                window.addSubview(stateContainerView)
                
                stateContainerView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
                stateContainerView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
                stateContainerView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
                stateContainerView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
                
                stateContainerView.layoutIfNeeded()
                
                let view = sceneView.view
                view.translatesAutoresizingMaskIntoConstraints = false
                stateContainerView.addSubview(view)
                
                view.topAnchor.constraint(equalTo: stateContainerView.topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: stateContainerView.bottomAnchor).isActive = true
                view.leadingAnchor.constraint(equalTo: stateContainerView.leadingAnchor).isActive = true
                view.trailingAnchor.constraint(equalTo: stateContainerView.trailingAnchor).isActive = true
                
                view.layoutIfNeeded()
                
                if animated {
                    UIView.animate(withDuration: 0.25) {
                        stateContainerView.alpha = 1.0
                    }
                } else {
                    view.layoutIfNeeded()
                }
                
                isFinish.accept(true)
                
            case let .dismissView(animated):
                
                let view = window.viewWithTag(self.HOST_VIEW_TAG)
                
                if animated {
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        view?.alpha = 0.0
                    }, completion: { (_) in
                        view?.removeFromSuperview()
                    })
                    
                } else {
                    view?.removeFromSuperview()
                }
                
                isFinish.accept(true)
            }
            
            
        }
        
        return isFinish
            .filter({$0})
            .take(1)
            .map({_ in ()})
    }
}
