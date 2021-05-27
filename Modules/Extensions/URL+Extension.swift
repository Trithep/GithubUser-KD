//
//  URL+Extension.swift
//  Action
//
//  Created by Nitikorn Ruengmontre on 23/6/2563 BE.
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
