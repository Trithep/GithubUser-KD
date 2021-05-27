//
//  Requestable.swift
//  Platform
//

import Foundation
import RxSwift

public protocol Requestable {
    var path: String { get }
    var pathQueries: Encodable? { get }
    var parameters: Encodable? { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var sampleData: Data? { get }
}

private extension String {
    static let GET: String = "GET"
    static let POST: String = "POST"
    static let PUT: String = "PUT"
    static let PATCH: String = "PATCH"
    static let DELETE: String = "DELETE"
}

public extension Requestable {
    
    var parameters: Encodable? { return nil }
    var pathQueries: Encodable? { return nil }
    var method: String { return "GET" }
    var headers: [String: String]? { return nil }
    var sampleData: Data? { return nil }
    
    func makeUrlRequest(baseURL: URL, additionalHeaders: [String: String] = [:]) -> Observable<URLRequest> {
        
        guard var components = URLComponents(string: baseURL.absoluteString) else { return .empty() }
        components.path = path
        
        if method == .GET, let json: [String : Any] = parameters?.toJSON() {
            components.queryItems = json.map({ URLQueryItem(name: $0.key, value: "\($0.value)")})
        }
        
        if let queries = pathQueries?.toQueryItems(), method != .GET {
            components.queryItems = queries
        }
     
        guard let url = components.url else { return .empty() }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        request.cachePolicy = .reloadIgnoringCacheData
          
        additionalHeaders.forEach({ (header) in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        })
        headers?.forEach({ (header) in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        })
        
        request.httpBody = parameters?.toJSONData()
        
        return .just(request)
    }
}
