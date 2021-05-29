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

enum FilterType {
    case all
    case favorite
}

protocol MainViewModelType {
    var inputs: MainViewModelInput { get }
    var outputs: MainViewModelOutput { get }
}

protocol MainViewModelInput {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var addFavoriteTrigger: PublishRelay<Int> { get }
    var openUserDetailTrigger: PublishRelay<Int> { get }
    var sortUserTrigger: PublishRelay<Void> { get }
    var filterUserTrigger: PublishRelay<FilterType> { get }
    var searchUserTrigger: BehaviorRelay<String> { get }
}

protocol MainViewModelOutput {
    var isLoading: Driver<Bool> { get }
    var sectionRows: Driver<[UserSection]> { get }
    var favoriteList: [Int] { get }
    var displaySortList: Driver<Void> { get }
    var sortStateChange: Driver<Bool> { get }
    var alertError: Driver<String> { get }
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
    var sortUserTrigger: PublishRelay<Void> = .init()
    var filterUserTrigger: PublishRelay<FilterType> = .init()
    var searchUserTrigger: BehaviorRelay<String> = .init(value: "")
    var displaySortList: Driver<Void> = .empty()
    var sortStateChange: Driver<Bool> = .empty()
    var alertError: Driver<String> = .empty()
    
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
    
    init(coordinator: SceneCoordinator, provider: UseCaseProviderDomain) {
        self.coordinator = coordinator
        self.provider = provider
        self.favoriteUsers = (UserDefaults.standard.array(forKey: "favorite_user") as? Array<Int>) ?? []
        
        var responseUsers: [User] = []
        var sortFlag: Bool = false
        
        let loading = ActivityIndicator()
        isLoading = loading.asDriver(onErrorDriveWith: .empty())
        
        let filterAll = filterUserTrigger.filter{$0 == .all}.map{_ in responseUsers}
        let filterFavorite = filterUserTrigger.filter{$0 == .favorite}.map{_ in responseUsers}
            .map{
                $0.filter { [weak self] user in
                    guard let self = self else { return false }
                    return self.favoriteUsers.contains(where: { $0 == user.userId })
                }
            }
        
        let sortResult = sortUserTrigger.map{_ in responseUsers}.do{ _ in sortFlag = !sortFlag }.share()
        
        sortStateChange = sortUserTrigger.map{() in return sortFlag}.asDriver(onErrorDriveWith: .empty())

        let searchUserResponse = searchUserTrigger.filter{!$0.isEmpty}
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged { (left, right) -> Bool in
                left == right
            }
            .flatMapLatest { text -> Observable<Event<UserSearch>> in
                return provider.makeUserUseCases().searchUser(userName: text)
                    .materialize().trackActivity(loading)
            }.filter{!$0.isCompleted}.share()
        
        let searchUserResult = searchUserResponse.elements().filter{$0.items != nil}.map{$0.items!}

        let emptySearchTrigger = searchUserTrigger.filter{$0.isEmpty}.map{_ in }
            .filter{ !responseUsers.isEmpty }.asObservable()
        
        let getUsersResponse = Observable.merge([viewDidLoadTrigger, emptySearchTrigger]).flatMapLatest { () -> Observable<Event<[User]>> in
            return provider.makeUserUseCases().getUser()
                .materialize().trackActivity(loading)
        }.filter{!$0.isCompleted}.share()
        
        let APIResponse = Observable.merge([getUsersResponse.elements(), searchUserResult])
            .do { responseUsers = $0 }
        
        let usersDataMerge = Observable.merge([APIResponse, filterAll, filterFavorite, sortResult])
            .map{ sortFlag ? $0.sorted(by:{ $0.login.lowercased() < $1.login.lowercased() }) : $0 }
        
        sectionRows = usersDataMerge
            .map{
                var items: [UserSectionRowItem] = []
                $0.enumerated().forEach { (index, user) in
                    let vm = UserTableCellViewModel(user: user)
                    items.append(UserSectionRowItem.userList(vm))
                }
                return [UserSection(items: items)]
            }
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
            .withLatestFrom(usersDataMerge, resultSelector: { index, users in
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

        alertError = Observable.merge([getUsersResponse.errors(), searchUserResponse.errors()])
            .map{ $0 as? APIError}
            .filter{ $0 != nil }
            .map{ $0!.message }
            .asDriver(onErrorDriveWith: .empty())
    }
}
