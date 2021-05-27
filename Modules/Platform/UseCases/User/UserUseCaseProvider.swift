//
//  UserUseCaseProvider.swift
//  Platform
//
import Foundation
import Domain
import Networking

public final class UserUseCaseProvider: Domain.UserUseCaseProvider {

    private let network: Networkable
    
    public init(network: Networkable) {
        self.network = network
    }
    
    public func makeUserUseCase() -> UserUseCaseDomain {
        return UserUseCase(network: network)
    }
    
}
