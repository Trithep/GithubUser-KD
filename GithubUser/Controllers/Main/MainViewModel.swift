//
//  MainViewModel.swift
//  GithubUser
//

import Foundation
import SceneCore
import RxSwift
import RxCocoa
import Domain
import Extensions

protocol MainViewModelType {
    var inputs: MainViewModelInput { get }
    var outputs: MainViewModelOutput { get }
}

protocol MainViewModelInput {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var addFavoriteTrigger: PublishRelay<Int> { get }
    var openUserDetailTrigger: PublishRelay<Int> { get }
}

protocol MainViewModelOutput {
    var isLoading: Driver<Bool> { get }
    var sectionRows: Driver<[UserSection]> { get }
    var favoriteList: [Int] { get }
}

final class MainViewModel: MainViewModelType, MainViewModelInput, MainViewModelOutput {
    
    var inputs: MainViewModelInput { return self }
    var outputs: MainViewModelOutput { return self }
    
    let viewDidLoadTrigger = PublishSubject<Void>()
    var isLoading: Driver<Bool> = .empty()
    var sectionRows: Driver<[UserSection]> = .empty()
    var favoriteList: [Int] { return favoriteUsers }
    var addFavoriteTrigger: PublishRelay<Int> = .init()
    var openUserDetailTrigger: PublishRelay<Int> = .init()
    
    private let bag = DisposeBag()
    private let coordinator: SceneCoordinator
    private let provider: UseCaseProviderDomain
    private var favoriteUsers: [Int] {
        willSet(newValue) {
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(newValue, forKey: "favorite_user")
                UserDefaults.standard.synchronize()
            }
        }
    }
    private var users: [User]
    
    init(coordinator: SceneCoordinator, provider: UseCaseProviderDomain) {
        self.coordinator = coordinator
        self.provider = provider
        self.favoriteUsers = (UserDefaults.standard.array(forKey: "favorite_user") as? Array<Int>) ?? []
        self.users = []
        
        let loading = ActivityIndicator()
        isLoading = loading.asDriver(onErrorDriveWith: .empty())
        
        let getUsersResponse = viewDidLoadTrigger.flatMapLatest { () -> Observable<Event<[User]>> in
            return provider.makeUserUseCases().getUser()
                .materialize().trackActivity(loading)
        }.filter{!$0.isCompleted}.share()

        sectionRows = getUsersResponse.elements()
            .map({ users in
                
                var items: [UserSectionRowItem] = []
                users.enumerated().forEach { (index, user) in
                    let vm = UserTableCellViewModel(user: user)
                    items.append(UserSectionRowItem.userList(vm))
                }
                
                return [UserSection(items: items)]
            })
          .asDriver(onErrorDriveWith: .empty())
        
        addFavoriteTrigger.bind { [weak self] userId in
            guard let self = self else { return }
  
            var favList = self.favoriteUsers
            if favList.contains(where: { $0 == userId}) {
                // remove fav
                favList = favList.filter({ $0 != userId })
            } else {
                // add fav
                favList.append(userId)
            }
            self.favoriteUsers = favList
            
        }.disposed(by: bag)
        
        openUserDetailTrigger
            .withLatestFrom(getUsersResponse.elements(), resultSelector: { index, users in
                users[index]
            })
            .bind { [weak self] user in
                guard let self = self else { return }
                let viewModel = UserRepositoryViewModel(coordinator: self.coordinator,
                                                        provider: self.provider,
                                                        owner: user)
                let scene = MainScene.repoList(viewModel: viewModel)
                self.coordinator.transition(type: .push(scene, false))
        }.disposed(by: bag)

    }
}
