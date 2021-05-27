//
//  UserTableViewModel.swift
//  GithubUser
//

import Foundation
import Domain

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
}

final class UserTableCellViewModel: UserTableListType, UserTableListInputs, UserTableListOutputs {
    
    var inputs: UserTableListInputs { return self }
    var outputs: UserTableListOutputs { return self }
    
    var imageUrl: URL? { return URL(string: user.avatarUrl ?? "") }
    var name: String { return user.login ?? "" }
    var url: String { return user.url ?? "" }

    private var user: User
    
    init(user: User) {
      self.user = user
    }
}
