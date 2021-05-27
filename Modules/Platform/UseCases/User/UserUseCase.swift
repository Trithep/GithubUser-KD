//
//  UserUseCase.swift
//  Platform
//
import Networking
import RxSwift
import Domain

class UserUseCase: Domain.UserUseCaseDomain {
    
    private let network: Networkable
    
    init(network: Networkable) {
        self.network = network
    }
    
    func getUser() -> Observable<User> {
        return network.request(UserRequest.users, errorType: APIError.self)
    }
}
