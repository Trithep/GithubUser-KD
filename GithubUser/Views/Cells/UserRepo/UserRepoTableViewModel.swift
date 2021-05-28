//
//  UserRepoTableViewModel.swift
//  GithubUser
//
import Foundation
import Domain
import RxCocoa
import RxSwift

protocol UserRepoTableListType {
  var inputs: UserRepoTableListInputs { get }
  var outputs: UserRepoTableListOutputs { get }
}

protocol UserRepoTableListInputs {
    
}

protocol UserRepoTableListOutputs {
    var name: String { get }
    var description: String { get }
    var language: String { get }
    var fork: String { get }
}

final class UserRepoTableViewModel: UserRepoTableListType, UserRepoTableListInputs, UserRepoTableListOutputs {
   
    var inputs: UserRepoTableListInputs { return self }
    var outputs: UserRepoTableListOutputs { return self }
    
    var favoriteDidTapped: PublishRelay<Int> = .init()
    
    var name: String { return user.name ?? "" }
    var description: String { return user.description ?? "" }
    var language: String { return user.language ?? "" }
    var fork: String { return "Forks: \(user.forks ?? 0)" }

    private var user: UserRepo
    private let disposeBag = DisposeBag()
    
    init(user: UserRepo) {
        self.user = user
    }
}
