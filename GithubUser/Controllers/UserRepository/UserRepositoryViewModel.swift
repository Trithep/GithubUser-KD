//
//  UserRepositoryViewModel.swift
//  GithubUser
//
import Foundation
import SceneCore
import RxSwift
import RxCocoa
import Domain
import Extensions

protocol UserRepositoryType {
    var inputs: UserRepositoryInputs { get }
    var outputs: UserRepositoryOutputs { get }
}

protocol UserRepositoryInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    func backPage()
}

protocol UserRepositoryOutputs {
    var isLoading: Driver<Bool> { get }
    var sectionRows: Driver<[UserSection]> { get }
    var headerViewModel: UserTableListType { get }
    var alertError: Driver<String> { get }
}

final class UserRepositoryViewModel: UserRepositoryType, UserRepositoryInputs, UserRepositoryOutputs {
    
    var inputs: UserRepositoryInputs { return self }
    var outputs: UserRepositoryOutputs { return self }
    
    let viewDidLoadTrigger = PublishSubject<Void>()
    var isLoading: Driver<Bool> = .empty()
    var sectionRows: Driver<[UserSection]> = .empty()
    var headerViewModel: UserTableListType {
        return UserTableCellViewModel(user: owner)
    }
    var alertError: Driver<String> = .empty()
    
    private let bag = DisposeBag()
    private let coordinator: SceneCoordinator
    private let provider: UseCaseProviderDomain
    private var owner: User
    
    init(coordinator: SceneCoordinator, provider: UseCaseProviderDomain, owner: User) {
        self.coordinator = coordinator
        self.provider = provider
        self.owner = owner
        
        let loading = ActivityIndicator()
        isLoading = loading.asDriver(onErrorDriveWith: .empty())
        
        let getUsersRepoResponse = viewDidLoadTrigger.flatMapLatest { () -> Observable<Event<[UserRepo]>> in
            return provider.makeUserUseCases().getUserRepo(userOwner: owner.login)
                .materialize().trackActivity(loading)
        }.filter{!$0.isCompleted}.share()
    
        sectionRows = getUsersRepoResponse.elements()
            .map({ users in
                
                var items: [UserSectionRowItem] = []
                users.enumerated().forEach { (index, user) in
                    let vm = UserRepoTableViewModel(user: user)
                    items.append(UserSectionRowItem.userRepo(vm))
                }
                
                return [UserSection(items: items)]
            })
          .asDriver(onErrorDriveWith: .empty())
        
        alertError = getUsersRepoResponse.errors()
            .map{ $0 as? APIError}
            .filter{ $0 != nil }
            .map{ $0!.message ?? "Something error" }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func backPage() {
        coordinator.transition(type: .pop(true))
    }
}
