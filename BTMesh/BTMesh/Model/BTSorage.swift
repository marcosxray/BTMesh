//
//  BTSorage.swift
//  BTMesh
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Protocol

public protocol BTStorageProtocol {
    var currentUser: BTUser? { get set }
    var users: BehaviorSubject<Array<BTUser>> { get set }
    func addUser(user: BTUser)
    func removeUser(user: BTUser)
}

// MARK: - Class

public class BTStorage: BTStorageProtocol {
    
    // MARK: - Public properties
    
    public static let shared = BTStorage()
    public var currentUser: BTUser?
    public var users = BehaviorSubject<Array<BTUser>>(value: [])
    
    // MARK: - Initialiation
    
    private init() {}
    
    // MARK: - Public methods
    
    public func addUser(user: BTUser) {
        var users = (try? self.users.value()) ?? []
        users.append(user)
        self.users.onNext(users)
    }
    
    public func removeUser(user: BTUser) {
        var users = (try? self.users.value()) ?? []
        guard let index = users.index(of: user) else { return }
        users.remove(at: index)
        self.users.onNext(users)
    }
}
