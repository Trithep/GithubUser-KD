//
//  User.swift
//

import Foundation

final public class User: Codable {
    
    public var login: String?
    public var userId: Int?
    public var nodeId: String?
    public var avatarUrl: String?
    public var gravatarId: String?
    public var url: String?
    public var htmlUrl: String?
    public var followersUrl: String?
    public var followingUrl: String?
    public var gistsUrl: String?
    public var starredUrl: String?
    public var subscriptionsUrl: String?
    public var organizationsUrl: String?
    public var reposUrl: String?
    public var eventsUrl: String?
    public var receivedEventsUrl: String?
    public var type: String?
    public var siteAdmin: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case login
        case userId = "id"
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "receivedEvents_url"
        case type
        case siteAdmin = "site_admin"
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try? container.decode(String.self, forKey: .login)
        userId = try? container.decode(Int.self, forKey: .userId)
        nodeId = try? container.decode(String.self, forKey: .nodeId)
        avatarUrl = try? container.decode(String.self, forKey: .avatarUrl)
        gravatarId = try? container.decode(String.self, forKey: .gravatarId)
        url = try? container.decode(String.self, forKey: .url)
        htmlUrl = try? container.decode(String.self, forKey: .htmlUrl)
        followersUrl = try? container.decode(String.self, forKey: .followersUrl)
        followingUrl = try? container.decode(String.self, forKey: .followingUrl)
        gistsUrl = try? container.decode(String.self, forKey: .gistsUrl)
        starredUrl = try? container.decode(String.self, forKey: .starredUrl)
        subscriptionsUrl = try? container.decode(String.self, forKey: .subscriptionsUrl)
        organizationsUrl = try? container.decode(String.self, forKey: .organizationsUrl)
        reposUrl = try? container.decode(String.self, forKey: .reposUrl)
        eventsUrl = try? container.decode(String.self, forKey: .eventsUrl)
        receivedEventsUrl = try? container.decode(String.self, forKey: .receivedEventsUrl)
        type = try? container.decode(String.self, forKey: .type)
        siteAdmin = try? container.decode(Bool.self, forKey: .siteAdmin)
    }
    
    public init() {}

}
