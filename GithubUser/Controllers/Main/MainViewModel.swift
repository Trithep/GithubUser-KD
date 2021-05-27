//
//  MainViewModel.swift
//  GithubUser
//
//  Created by Trithep Thumrongluck on 27/5/2564 BE.
//

import Foundation
import SceneCore
import RxSwift
import RxCocoa
import Domain

protocol MainViewModelType {
    var inputs: MainViewModelInput { get }
    var outputs: MainViewModelOutput { get }
}

protocol MainViewModelInput {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
}

protocol MainViewModelOutput {
    var title: Driver<User> { get }
    var usersResult: Driver<[User]> { get }
}

final class MainViewModel: MainViewModelType, MainViewModelInput, MainViewModelOutput {
    
    var inputs: MainViewModelInput { return self }
    var outputs: MainViewModelOutput { return self }
    
    let viewDidLoadTrigger = PublishSubject<Void>()
    var title: Driver<User> = .empty()
    var usersResult: Driver<[User]> = .empty()
    
    private let bag = DisposeBag()
    private let coordinator: SceneCoordinator
    private let provider: UseCaseProviderDomain
    
    init(coordinator: SceneCoordinator, provider: UseCaseProviderDomain) {
        self.coordinator = coordinator
        self.provider = provider
        
        let getUsersResponse = viewDidLoadTrigger.flatMapLatest { () -> Observable<Event<[User]>> in
            return provider.makeUserUseCases().getUser().materialize()
        }.filter{!$0.isCompleted}

        usersResult = getUsersResponse.elements()
          .asDriver(onErrorDriveWith: .empty())

    }
}
