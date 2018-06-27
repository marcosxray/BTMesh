//
//  Sorage.swift
//  BTMesh
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Protocol

public protocol StorageProtocol {
    var currentUser: User? { get set }
    var users: BehaviorSubject<Array<User>> { get set }
    func addUser(user: User)
    func removeUser(user: User)
}

// MARK: - Class

public class Storage: StorageProtocol {
    
    // MARK: - Public properties
    
    public static let shared = Storage()
    public var currentUser: User?
    public var users = BehaviorSubject<Array<User>>(value: [])
    
    // MARK: - Initialiation
    
    private init() {}
    
    // MARK: - Public methods
    
    public func addUser(user: User) {
        var users = (try? self.users.value()) ?? []
        users.append(user)
        self.users.onNext(users)
    }
    
    public func removeUser(user: User) {
        var users = (try? self.users.value()) ?? []
        guard let index = users.index(of: user) else { return }
        users.remove(at: index)
        self.users.onNext(users)
    }
}
