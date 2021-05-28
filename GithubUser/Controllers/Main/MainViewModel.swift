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
    var addFavoriteTrigger: PublishRelay<Int> { get }
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
    
    private let bag = DisposeBag()
    private let coordinator: SceneCoordinator
    private let provider: UseCaseProviderDomain
    private var favoriteUsers: [Int]
    
    init(coordinator: SceneCoordinator, provider: UseCaseProviderDomain) {
        self.coordinator = coordinator
        self.provider = provider
        self.favoriteUsers = (UserDefaults.standard.array(forKey: "favorite_user") as? Array<Int>) ?? []
        
        let getUsersResponse = viewDidLoadTrigger.flatMapLatest { () -> Observable<Event<[User]>> in
            return provider.makeUserUseCases().getUser().materialize()
        }.filter{!$0.isCompleted}

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
            UserDefaults.standard.setValue(favList, forKey: "favorite_user")
            UserDefaults.standard.synchronize()
            self.favoriteUsers = favList
            
        }.disposed(by: bag)

    }
}
