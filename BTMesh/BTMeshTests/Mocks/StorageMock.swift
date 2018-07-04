//
//  StorageMocks.swift
//  BTMeshTests
//
//  Created by Marcos on 01/07/2018.
//  Copyright © 2018 Marcos Borges. All rights reserved.
//

import Foundation
import RxSwift
@testable import BTMesh

// MARK: - Mocks

 class StorageMock: BTStorageProtocol {
    
    // MARK: - Public properties
    
    public var currentUser: BTUser?
    public var users = BehaviorSubject<Array<BTUser>>(value: [])
    
    // MARK: - Public methods
    
    public func addUser(user: BTUser) {
        var users = (try? self.users.value()) ?? []
        users.append(user)
        self.users.onNext(users)
    }
    
    public func removeUser(user: BTUser) {}
    
    // MARK: - Test methods
    
    func fireVisibleItemsChange() {
        
    }
}
