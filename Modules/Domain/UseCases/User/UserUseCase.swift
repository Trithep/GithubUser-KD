//
//  UserUseCase.swift
//  Domain
//
//  Created by Trithep Thumrongluck on 27/5/2564 BE.
//

import Foundation
import RxSwift

public protocol UserUseCaseDomain {
    func getUser() -> Observable<User>
}
