//
//  SceneTransition.swift
//  

import Foundation

public enum SceneTransition {
    
    case root(Scene, Bool)
    case modal(Scene, Bool)
    case modalWithCompletion(Scene, Bool, () -> ())
    case modalTab(Scene, Bool)
    
    /// Present as modal over current context by full screen.
    case modalOver(Scene, Bool)
    
    case cardModal(Scene, Bool)
    case customModal(Scene, Bool)
    case push(Scene, Bool)
    case pop(Bool)
    case popTo(UIViewController.Type, Bool)
    case popToRoot(Bool)
    case dismiss(Bool)
    
    /// Dismiss viewcontroller since first found as type specific.
    ///
    /// ViewControllers will find from topmost to ground.
    case dismissFrom(UIViewController.Type, Bool, (() -> ())?)
    
    case dismissWithCompletion(Bool, () -> ())
    case dismissToRootWithCompletion(Bool, (()->())?)
    case modalView(SceneView, Bool)
    case dismissView(Bool)
    case open(URL)
}
