//
//  UserTableViewModel.swift
//  GithubUser
//

import Foundation
import Domain
import RxCocoa
import RxSwift

protocol UserTableListType {
  var inputs: UserTableListInputs { get }
  var outputs: UserTableListOutputs { get }
}

protocol UserTableListInputs {
    
}

protocol UserTableListOutputs {
    var imageUrl: URL? { get }
    var name: String { get }
    var url: String { get }
    var userId: Int { get }
}

final class UserTableCellViewModel: UserTableListType, UserTableListInputs, UserTableListOutputs {
    
    var inputs: UserTableListInputs { return self }
    var outputs: UserTableListOutputs { return self }
    
    var imageUrl: URL? { return URL(string: user.avatarUrl ?? "") }
    var name: String { return user.login ?? "" }
    var url: String { return user.url ?? "" }
    var userId: Int { return user.userId ?? 0 }

    private var user: User
    private let disposeBag = DisposeBag()
    
    init(user: User) {
        self.user = user
    }
}
