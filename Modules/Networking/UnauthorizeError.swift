//
//  UnauthorizeError.swift
//  Networking
//
import Foundation

final public class UnauthorizeError: Codable, Error {
    
    public var data: UnauthorizeErrorData?
    public var message: String?
    
    enum BaseCodingKeys: String, CodingKey {
        case error
    }
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
    }
    
    required public init(from decoder: Decoder) throws {
        let base = try decoder.container(keyedBy: BaseCodingKeys.self)
        let container = try base.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
        data = try? container.decode(UnauthorizeErrorData.self, forKey: .data)
        message = try? container.decode(String.self, forKey: .message)
    }
    
    init() {}
}

final public class UnauthorizeErrorData: Codable, Error {
    
    public var returnCode: String?
    public var returnDesc: String?
    public var returnDescTH: String?
    
    enum CodingKeys: String, CodingKey {
        case returnCode
        case returnDesc
        case returnDescTH
    }
    
    required public init(from decoder: Decoder) throws {
        let base = try decoder.container(keyedBy: CodingKeys.self)
        returnCode = try? base.decode(String.self, forKey: .returnCode)
        returnDesc = try? base.decode(String.self, forKey: .returnDesc)
        returnDescTH = try? base.decode(String.self, forKey: .returnDescTH)
    }
    
    init() {}
}
