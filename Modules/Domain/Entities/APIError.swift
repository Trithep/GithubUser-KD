//
//  Error.swift
//  Domain
//
import Foundation

final public class APIError: Codable, Error {
    
    public var message: String = "Something error"
    
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message) 
    }
    
    public init() {}

}

