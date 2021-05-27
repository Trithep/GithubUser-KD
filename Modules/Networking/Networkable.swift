//
//  Networkable.swift
//  Domain
//
import Foundation
import RxSwift
import RxCocoa

public protocol Networkable {
    func request<T, U>(_ request: Requestable, errorType: U.Type) -> Observable<T> where T : Decodable, U : Decodable, U : Error
}

public protocol NetworkableInfo {
    var url: URL { get }
}

public class URLSessionNetwork: Networkable, NetworkableInfo {
    
    public enum Environment {
        case local
        case server
    }
    
    private let baseURL: URL
    private var environment: Environment = .server
    private let decoder: JSONDecoder
    private let headers: [String: String]
    private var sessionDelegate = URLSessionEncryption()
    
    public init(base url: URL) {
        self.baseURL = url
        
        let defaultDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.calendar = Calendar(identifier: .gregorian)
        defaultDecoder.dateDecodingStrategy = .formatted(formatter)
        self.decoder = defaultDecoder
        self.headers = [:]
    }
    
    public init(base url: URL, environment: Environment = .server, decoder: JSONDecoder? = nil, headers: [String: String] = [:]) {
        self.baseURL = url
        self.environment = environment
        
        if let customDecoder = decoder {
            self.decoder = customDecoder
        } else {
            let defaultDecoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.calendar = Calendar(identifier: .gregorian)
            defaultDecoder.dateDecodingStrategy = .formatted(formatter)
            self.decoder = defaultDecoder
        }
        self.headers = headers
    }
    
    private lazy var session: URLSession = {
        URLSession(configuration: .ephemeral, delegate: sessionDelegate, delegateQueue: nil)
    }()
    
    func makeRequest(_ request: Requestable, requireRenewToken: Bool = true) -> Observable<URLRequest> {
    
        return request.makeUrlRequest(baseURL: baseURL, additionalHeaders: headers)
    }

    public func request<T, U>(_ request: Requestable, errorType: U.Type) -> Observable<T> where T : Decodable, U : Decodable, U: Error {
        
        if let data = request.sampleData, environment == .local {
            
            do {
                let entity = try self.decoder.decode(T.self, from: data)
                return Observable.just(entity)
            } catch {
                return Observable.error(error)
            }
            
        }
        
        return request.makeUrlRequest(baseURL: self.baseURL, additionalHeaders: headers)
            .flatMap { (request) -> Observable<T> in
                return self.callApi(request: request, errorType: errorType)
        }
    }
    
    private func callApi<T, U>(request: URLRequest, errorType: U.Type) -> Observable<T> where T : Decodable, U : Decodable, U: Error {

        return Observable.create { [unowned self] (observer) -> Disposable in
            
            let task = self.session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                guard let data = data else {
                    observer.onError(error ?? NetworkError.response)
                    return
                }
                
                do {
            
                    let entity = try self.decoder.decode(T.self, from: data)
                    observer.onNext(entity)
                    observer.onCompleted()
                } catch _ {
                    
                    do {
                        let errorEntity = try self.decoder.decode(U.self, from: data)
                        observer.onError(errorEntity)
                    } catch {
                        observer.onError(NetworkError.decodeEntity)
                    }
                }
            })
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    // MARK: Networkable Info
    public var url: URL {
        return baseURL
    }
}

private class URLSessionEncryption: NSObject, URLSessionDelegate {
    
    var isNeedEncrypt: Bool = false
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        completionHandler(.performDefaultHandling, nil)
    }
}
