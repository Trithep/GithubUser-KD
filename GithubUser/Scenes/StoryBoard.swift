//
//  StoryBoard.swift
//  GithubUser
//
import UIKit

enum Story: String {
    case Main
    
}

extension Story {
    func build<V, T: BaseViewController<V>>(_ viewModel: V, identifier: String? = nil) -> T {
        print("\(self.rawValue) -> \(T.self)")
        return UIStoryboard.by(self).instantiate(viewModel, identifier: identifier)
    }
}

extension UIStoryboard {

    static func by(_ storyboard: Story) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil)
    }

    func instantiate<T: UIViewController>() -> T {
        guard let vc = instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError()
        }
        return vc
    }

    func instantiate<V, T: BaseViewController<V>>(_ viewModel: V, identifier: String? = nil) -> T {

        let vcIdentifier = identifier ?? String(describing: T.self)

        guard let vc = instantiateViewController(withIdentifier: vcIdentifier) as? T else {
            fatalError()
        }
        vc.bindViewModel(viewModel)
        return vc
    }
}

