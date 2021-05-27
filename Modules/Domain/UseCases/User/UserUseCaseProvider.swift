//
//  UserUseCaseProvider.swift
//  Domain
//
//  Created by Trithep Thumrongluck on 27/5/2564 BE.
//

import Foundation

public protocol UserUseCaseProvider {
    func makeUserUseCase() -> UserUseCaseDomain
}
