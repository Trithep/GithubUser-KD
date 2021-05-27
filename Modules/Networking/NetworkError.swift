//
//  NetworkError.swift
//  Domain
//
import Foundation

public enum NetworkError: Error {
    case makeRequest
    case response
    case decodeEntity
    case contentType
    case status(Int)
    case custom(Decodable)
    case unauthorize
}
