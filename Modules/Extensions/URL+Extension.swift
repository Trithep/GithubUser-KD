//
//  URL+Extension.swift
//  Action
//
import Foundation

public extension URL {
    var queryDictionary: [String: String]? {
        var queryStrings = [String: String]()
        let queryComponent = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems

        guard let _queryComponent = queryComponent else { return nil }
        
        for data in _queryComponent where data.value != nil {
            queryStrings[data.name] = data.value
        }
        return queryStrings
    }
}
