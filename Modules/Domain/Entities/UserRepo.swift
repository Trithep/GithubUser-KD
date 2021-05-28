//
//  UserRepo.swift
//  Domain
//

final public class UserRepo: Codable {
    
    public var userId: Int?
    public var description: String?
    public var name: String?
    public var owner: User?
    public var language: String?
    public var forks: Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case description
        case name
        case owner
        case language
        case forks
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try? container.decode(Int.self, forKey: .userId)
        description = try? container.decode(String.self, forKey: .description)
        name = try? container.decode(String.self, forKey: .name)
        owner = try? container.decode(User.self, forKey: .owner)
        language = try? container.decode(String.self, forKey: .language)
        forks = try? container.decode(Int.self, forKey: .forks)
    }
    
    public init() {}

}
