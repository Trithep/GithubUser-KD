//
//  Encodable.swift
//  Platform
//

import Foundation

extension Encodable {
    
    func toJSONData(toSnakeCase: Bool = false) -> Data? {
        
        let encoder = JSONEncoder()
          encoder.outputFormatting = [.prettyPrinted]

        if toSnakeCase {
            encoder.keyEncodingStrategy = .convertToSnakeCase
        }
        
        return try? encoder.encode(self)
    }
    
    func toJSON<T>() -> T? {
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }
        
        return try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? T
    }
    
    var hashValue: Int {
        return toJSONData()?.hashValue ?? -1
    }

    func toQueryItems() -> [URLQueryItem]? {
        guard let json: [String: Any]? = toJSON() else { return nil }
        
        return json?.compactMap({ (arg) -> URLQueryItem? in
            let (key, value) = arg
            let valString = value as? String
            return URLQueryItem(name: key, value: valString)
        })
    }
}
