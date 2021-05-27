//
//  Error.swift
//  Domain
//
import Foundation

final public class APIError: Codable, Error {
    
    public var message: String?
    
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try? container.decode(String.self, forKey: .message)
    }
    
    public init() {}

}

/*
 {
   "message": "Requires authentication",
   "documentation_url": "https://docs.github.com/rest/reference/users#get-the-authenticated-user"
 }
 */
