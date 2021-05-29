//
//  UIViewController+Extension.swift
//  Core
//

import UIKit
import MBProgressHUD

extension UIViewController {
    public func coreMakeNavbarTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    public func hideKeyboardWhenTappedOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Device size
extension UIViewController {
    
    public var navBarHeightValue: CGFloat {
        return navigationController?.navigationBar.frame.height ?? 0
    }
    
    public var deviceWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var deviceHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}

extension UIViewController {
    
    public var coreIsSpinning: Bool {
        return MBProgressHUD(view: view) != nil
    }
    
    public func coreShowSpinner(_ title: String = "", ignoreDuplicate: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if MBProgressHUD(view: strongSelf.view) != nil, !ignoreDuplicate { return }
            let spinnerActivity = MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
            spinnerActivity.contentColor = .white
            spinnerActivity.bezelView.backgroundColor = .black
            spinnerActivity.bezelView.alpha = 0.8
            
            if !title.isEmpty {
                spinnerActivity.label.text = title
            }
        }
    }
    
    public func coreHideSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: strongSelf.view, animated: true)
        }
    }
    
    public func coreShowInputDialog(title: String? = nil,
                                    subtitle: String? = nil,
                                    actionTitle: String? = "ตกลง",
                                    cancelTitle: String? = "ยกเลิก",
                                    inputPlaceholder: String? = nil,
                                    inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                                    cancelHandler: ((UIAlertAction) -> Void)? = nil,
                                    actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action: UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    public class func create<T: UIViewController>(from storyboard: String, in bundle: Bundle) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        let identifier = String(describing: T.self)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Could not load UIViewController of type: \(identifier)")
        }
        
        return viewController
    }
}

extension UIViewController {
    public class func getTopViewController() -> UIViewController? {
      guard let window = UIApplication.shared.keyWindow, var topViewController = window.rootViewController else { return nil }
      while let presentedViewController = topViewController.presentedViewController {
        topViewController = presentedViewController
      }
      
      return topViewController
    }
}

public extension UIViewController {
    
    class func getBottomSafeArea() -> CGFloat {
        let bottomSafeArea: CGFloat
        if #available(iOS 11.0, *) {
            bottomSafeArea = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom ?? 0
        } else {
            bottomSafeArea = UIApplication.shared.keyWindow?.rootViewController?.bottomLayoutGuide.length ?? 0
        }
        return bottomSafeArea
    }
}
