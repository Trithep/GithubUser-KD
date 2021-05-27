import Foundation
import UIKit
import RxSwift
import RxCocoa

// MARK: - ViewController Event
public extension Reactive where Base: UIViewController {
  var touchesBegan: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.touchesBegan(_:with:)))
  }
  
  var touchesEnded: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.touchesEnded(_:with:)))
  }
  
  var viewDidLoad: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.viewDidLoad))
  }
  
  var viewWillAppear: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.viewWillAppear(_:)))
  }
  
  var viewDidAppear: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.viewDidAppear(_:)))
  }
  
  var viewWillDisappear: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.viewWillDisappear(_:)))
  }
    
  var viewDidDisappear: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.viewDidDisappear(_:)))
  }
  
  func controlEvent(selector: Selector) -> ControlEvent<Void> {
    let source = methodInvoked(selector).map { (_) in () }
    return ControlEvent(events: source)
  }
}

// MARK: - ViewController Element and Error
public extension ObservableType where Element: EventConvertible {
    func elements() -> Observable<Element.Element> {
        return self.filter({ $0.event.element != nil }).map({ $0.event.element! })
    }
    func errors() -> Observable<Error> {
        return self.filter({ $0.event.error != nil }).map({ $0.event.error! })
    }
}

//MARK :- Rx Extend Text Color
extension Reactive where Base: UIButton {
    public func textColor(_ state: UIControl.State) -> Binder<UIColor?> {
       return Binder(self.base) { button, color in
           button.setTitleColor(color, for: state)
       }
   }
}

public protocol BoolType {
    var value: Bool { get }
}

extension Bool: BoolType {
    public var value: Bool {
        self
    }
}

public protocol OptionalType {
    associatedtype Wrapped

    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

public extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}

public extension Observable where Element: BoolType {
    func filterTrue() -> Observable<Element> {
        return filter({$0.value})
    }
    
    func filterFalse() -> Observable<Element> {
        return filter({!$0.value})
    }
}

public extension Observable {

    func mapValue<T>(_ value: T) -> Observable<T> {
        return map { (_) -> T in
            return value
        }
    }

    func mapVoid() -> Observable<Void> {
        return map { (_) -> Void in
            return ()
        }
    }
}

public extension ControlProperty {

    func twoWayBind (to relay: BehaviorRelay<Element>) -> Disposable {

        let bindToUIDisposable = relay.bind(to: self)

        let bindToRelay = self.subscribe(onNext: { n in
                relay.accept(n)
            }, onCompleted: {
                bindToUIDisposable.dispose()
            })

        return Disposables.create(bindToUIDisposable, bindToRelay)
    }
}

extension ObservableType {

    /**
    Returns an observable sequence containing as many elements as its input but all of them are the constant provided as a parameter
    
    - parameter value: A constant that each element of the input sequence is being replaced with
    - returns: An observable sequence containing the values `value` provided as a parameter
    */
    public func mapTo<R>(_ value: R) -> Observable<R> {
        return map { _ in value }
    }
}

