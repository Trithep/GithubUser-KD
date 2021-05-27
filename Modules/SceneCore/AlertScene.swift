import Foundation
import UIKit

public enum AlertScene {
    case alert(title: String, message: String, dismiss: (UIAlertAction) -> ())
}


extension AlertScene: Scene {
    public var viewController: UIViewController {
        
        switch self {
        case let .alert(title, message, dismiss):
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: dismiss)
            alertController.addAction(cancelAction)
            return alertController
        }
    }
}
