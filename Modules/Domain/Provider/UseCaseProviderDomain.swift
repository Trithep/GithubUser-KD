//
//  UseCaseProviderDomain.swift
//  Action
//
import Foundation

public protocol UseCaseProviderDomain {
    
    func makeUserUseCases() -> UserUseCaseDomain
}
