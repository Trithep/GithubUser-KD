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
    
    var sampleData: Data? {
        switch self {
        case .search:
            let json = """
              {
                "total_count": 33309,
                "incomplete_results": false,
                "items": [
                  {
                    "login": "wy",
                    "id": 1134163,
                    "node_id": "MDQ6VXNlcjExMzQxNjM=",
                    "avatar_url": "https://avatars.githubusercontent.com/u/1134163?v=4",
                    "gravatar_id": "",
                    "url": "https://api.github.com/users/wy",
                    "html_url": "https://github.com/wy",
                    "followers_url": "https://api.github.com/users/wy/followers",
                    "following_url": "https://api.github.com/users/wy/following{/other_user}",
                    "gists_url": "https://api.github.com/users/wy/gists{/gist_id}",
                    "starred_url": "https://api.github.com/users/wy/starred{/owner}{/repo}",
                    "subscriptions_url": "https://api.github.com/users/wy/subscriptions",
                    "organizations_url": "https://api.github.com/users/wy/orgs",
                    "repos_url": "https://api.github.com/users/wy/repos",
                    "events_url": "https://api.github.com/users/wy/events{/privacy}",
                    "received_events_url": "https://api.github.com/users/wy/received_events",
                    "type": "User",
                    "site_admin": false,
                    "score": 1.0
                  },
                  {
                    "login": "wycats",
                    "id": 4,
                    "node_id": "MDQ6VXNlcjQ=",
                    "avatar_url": "https://avatars.githubusercontent.com/u/4?v=4",
                    "gravatar_id": "",
                    "url": "https://api.github.com/users/wycats",
                    "html_url": "https://github.com/wycats",
                    "followers_url": "https://api.github.com/users/wycats/followers",
                    "following_url": "https://api.github.com/users/wycats/following{/other_user}",
                    "gists_url": "https://api.github.com/users/wycats/gists{/gist_id}",
                    "starred_url": "https://api.github.com/users/wycats/starred{/owner}{/repo}",
                    "subscriptions_url": "https://api.github.com/users/wycats/subscriptions",
                    "organizations_url": "https://api.github.com/users/wycats/orgs",
                    "repos_url": "https://api.github.com/users/wycats/repos",
                    "events_url": "https://api.github.com/users/wycats/events{/privacy}",
                    "received_events_url": "https://api.github.com/users/wycats/received_events",
                    "type": "User",
                    "site_admin": false,
                    "score": 1.0
                  }
                ]
              }
            """
            return json.data(using: .utf8)!
        default:
            return nil
        }
    }
    
}


