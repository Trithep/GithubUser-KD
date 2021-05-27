//
//  AlertViewModel.swift
//  SceneCore
//

import Foundation
import RxSwift
import RxCocoa

public enum AlertAction {
    case none
    case left
    case right
}

public protocol AlertInput {
    var action: PublishRelay<AlertAction> { get }
}

public protocol AlertOutput {
    var title: String? { get }
    var message: String? { get }
    var leftTitle: String? { get }
    var rightTitle: String? { get }
    var boldAction: AlertBoldAction? { get }
}

public protocol AlertViewModelType {
    var input: AlertInput { get }
    var output: AlertOutput { get }
}

public enum AlertBoldAction {
    case left
    case right
}

public final class AlertViewModel: AlertViewModelType, AlertInput, AlertOutput {
    
    public var input: AlertInput { return self }
    public var output: AlertOutput { return self }
    
    public let action = PublishRelay<AlertAction>()
    
    public var title: String?
    public var message: String?
    public var leftTitle: String?
    public var rightTitle: String?
    public var boldAction: AlertBoldAction?
    
    public init() {
        
    }
    
    public init(title: String?, message: String?, leftTitle: String?, rightTitle: String? = nil, boldAction: AlertBoldAction? = .right) {
        self.title = title ?? ""
        self.message = message
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        self.boldAction = boldAction
    }
}
