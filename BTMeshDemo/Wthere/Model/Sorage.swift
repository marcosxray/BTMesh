//
//  Sorage.swift
//  Wthere
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Protocol

protocol StorageProtocol {
    var currentUser: User? { get set }
    var users: BehaviorSubject<Set<User>> { get set }
}

// MARK: - Class

class Storage: StorageProtocol {
    
    // MARK: - Public properties
    
    static let shared = Storage()
    var currentUser: User?
    var users = BehaviorSubject<Set<User>>(value: [])
    
    // MARK: - Initialiation
    
    private init() {}
    
    // MARK: - Public methods
    
    func addUser(user: User) {
        var users = (try? self.users.value()) ?? []
        users.insert(user)
        self.users.onNext(users)
    }
    
    func removeUser(user: User) {
        var users = (try? self.users.value()) ?? []
        guard let index = users.index(of: user) else { return }
        users.remove(at: index)
        self.users.onNext(users)
    }
}
