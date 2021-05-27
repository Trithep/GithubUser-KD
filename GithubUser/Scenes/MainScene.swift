//
//  MainScene.swift
//  GithubUser
//
import UIKit
import SceneCore

enum MainScene {
    case main(viewModel: MainViewModelType)
}

extension MainScene: Scene {

    var viewController: UIViewController {

        let mainStory = Story.Main

        switch self {

        case let .main(viewModel):
            return mainStory.build(viewModel) as MainViewController
        }
    }
}
