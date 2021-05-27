//
//  UserRequest.swift
//  Platform
//
import Foundation
import Networking

enum UserRequest {
    case users
}

extension UserRequest: Requestable {
    var path: String {
        switch  self {
        case .users:
            return "/users" /// https://api.github.com/users
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


