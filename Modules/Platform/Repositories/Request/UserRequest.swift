//
//  UserRequest.swift
//  Platform
//
import Foundation
import Networking

enum UserRequest {
    case users
    case userRepo(userOwner: String)
}

extension UserRequest: Requestable {
    var path: String {
        switch  self {
        case .users:
            return "/users"
        case let .userRepo(userOwner):
            return "/users/\(userOwner)/repos"
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
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    
}


