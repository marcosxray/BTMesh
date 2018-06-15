//
//  WthereTests.swift
//  BTMeshTests
//
//  Created by Marcos Borges on 12/06/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import XCTest
import RxSwift
@testable import Wthere

class WthereTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRouting() {
        let nodeA = NodeFactory.generateNode_A()
        let nodeB = NodeFactory.generateNode_B()
        let nodeC = NodeFactory.generateNode_C()
        let nodeD = NodeFactory.generateNode_D()
        let nodeE = NodeFactory.generateNode_E()
        let nodeF = NodeFactory.generateNode_F()
        let nodeG = NodeFactory.generateNode_G()
        let nodeH = NodeFactory.generateNode_H()
        let nodeI = NodeFactory.generateNode_I()
        
        let userA = User(node: nodeA)
        let userB = User(node: nodeB)
        let userC = User(node: nodeC)
        let userD = User(node: nodeD)
        let userE = User(node: nodeE)
        let userF = User(node: nodeF)
        let userG = User(node: nodeG)
        let userH = User(node: nodeH)
        let userI = User(node: nodeI)
        
        let storage = StorageMock()
        storage.addUser(user: userA)
        storage.addUser(user: userB)
        storage.addUser(user: userC)
        storage.addUser(user: userD)
        storage.addUser(user: userE)
        storage.addUser(user: userF)
        storage.addUser(user: userG)
        storage.addUser(user: userH)
        storage.addUser(user: userI)
        
        storage.currentUser = userA
        let router = BTRouter(border: BTBorder(), storage: storage)
        
        repeat {
            guard let user = router.escapeForUser(user: userI) else { continue }
            print("Node: \(storage.currentUser!.name)")
            
            if user == storage.currentUser {
                storage.currentUser = userI
                print("Node: I")
                break
            }
            
            storage.currentUser = user
        } while storage.currentUser != userI
        
        XCTAssertEqual(storage.currentUser, userI)
    }
}

// MARK: - Mocks

class StorageMock: StorageProtocol {
    var currentUser: User?
    var users: BehaviorSubject<Set<User>> = BehaviorSubject<Set<User>>(value: [])
    
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
