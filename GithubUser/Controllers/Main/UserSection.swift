//
//  UserSection.swift
//  GithubUser
//
import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Action

struct UserSection: AnimatableSectionModelType {
    init(original: UserSection, items: [UserSectionRowItem]) {
        self = original
        self.items = items
    }

    typealias Item = UserSectionRowItem
    typealias Identity = String

    var identity: String {
        return "landing"
    }

    var items: [Item]

    init(items: [Item]) {
        self.items = items
    }
}

extension UserSection: IdentifiableType {}

enum UserSectionRowItem {
    case userList(UserTableListType)
}

extension UserSectionRowItem: IdentifiableType, Equatable {
    
    static func == (lhs: UserSectionRowItem, rhs: UserSectionRowItem) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    var identity: String {
        
        switch self {
        case .userList:
            return "UserTableViewCell"
        }
    }
}
