//
//  SceneCore
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public final class ImagePickerScene: NSObject, Scene, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let vc = UIImagePickerController()
    private let imageResponse = PublishRelay<UIImage?>()
    
    public var image: Observable<UIImage?> {
        imageResponse.asObservable().take(1)
    }
    
    public var viewController: UIViewController {
        vc
    }
    
    public init(type: UIImagePickerController.SourceType = .photoLibrary, allowsEditing: Bool = true) {
        super.init()
        vc.delegate = self
        vc.sourceType = type
        vc.allowsEditing = allowsEditing
    }
    
    public func show(to viewController: UIViewController) {
        viewController.present(vc, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            self.imageResponse.accept(info[UIImagePickerController.InfoKey.editedImage] as? UIImage)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.imageResponse.accept(nil)
        }
    }
}
