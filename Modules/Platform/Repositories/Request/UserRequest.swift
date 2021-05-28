//
//  UserRequest.swift
//  Platform
//
import Foundation
import Networking

enum UserRequest {
    case users
    case userRepo(userOwner: String)
    case search(text: String)
}

extension UserRequest: Requestable {
    var path: String {
        switch  self {
        case .users:
            return "/users"
        case let .userRepo(userOwner):
            return "/users/\(userOwner)/repos"
        case .search:
            return "/search/users"
        }
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    var parameters: Encodable? {
        switch self {
        case let .search(text):
            return ["q" : text]
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
    
}


