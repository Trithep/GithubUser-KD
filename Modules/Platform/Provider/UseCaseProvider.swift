//
//  UseCaseProvider.swift
//

import Foundation
import Networking
import Domain

public enum TargetEnvironment {
    case development
    case staging
    case production
    case test
}

public final class UseCaseProvider: UseCaseProviderDomain {

    private let network: Networkable
    private let target: TargetEnvironment
    
    public init(network: Networkable,
         target: TargetEnvironment = .production) {
        
        self.network = network
        self.target = target
    }
    
    public func makeUserUseCases() -> UserUseCaseDomain {
        return UserUseCase.init(network: network)
    }
}
