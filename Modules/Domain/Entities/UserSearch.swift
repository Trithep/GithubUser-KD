//
//  UserSearch.swift
//  Domain
//

final public class UserSearch: Codable {
    
    public var totalCount: Int?
    public var result: Bool?
    public var items: [User]?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case result
        case items
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try? container.decode(Int.self, forKey: .totalCount)
        result = try? container.decode(Bool.self, forKey: .result)
        items = try? container.decode([User].self, forKey: .items)
    }
    
    public init() {}

}
