//
//  BTRouterTests.swift
//  BTMeshTests
//
//  Created by Marcos on 12/06/2018.
//  Copyright © 2018 Marcos Borges. All rights reserved.
//

import XCTest
import RxSwift
@testable import BTMesh

// MARK: - Class

class BTRouterTests: XCTestCase {
    
    // MARK: - Public properties
    
    var bag = DisposeBag()
    
    var router: BTRouter!
    var storage: BTStorageProtocol!
    var border: BorderMock!
    
    var userA: BTUser!
    var userB: BTUser!
    var userC: BTUser!
    var userD: BTUser!
    var userE: BTUser!
    var userF: BTUser!
    var userG: BTUser!
    var userH: BTUser!
    var userI: BTUser!
    
    // MARK: - Overridden methods
    
    override func setUp() {
        super.setUp()
        storage = StorageMock()
        loadMeshNodes()
        configRouter()
    }
    
    override func tearDown() {
        super.tearDown()
        storage.users.onNext([])
    }
    
    // MARK: - Tests
    
    func testRoutingFromNodeAToNodeI() {
        storage.currentUser = userA
        var nodePath = ""

        repeat {
            guard let user = router.escapeForUser(user: userI) else { continue }

            nodePath += storage.currentUser!.name
            print("Node: \(String(describing: storage.currentUser!.name))")

            if user == storage.currentUser {
                storage.currentUser = userI
                print("Node: I")
                break
            }

            storage.currentUser = user
        } while storage.currentUser != userI

        XCTAssertEqual(nodePath, "ACF")
        XCTAssertEqual(storage.currentUser, userI)
    }
    
    func testEscapeForUser() {
        storage.currentUser = userD
        let userEscape = router.escapeForUser(user: userF)
        XCTAssertEqual(userEscape, userC)
    }

    func testRouteItemForNode() {
        storage.currentUser = userB
        let item = router.routeItemForNode(node: userI.node)
        XCTAssertEqual(item?.escapeNodeIdentifier, userF.node.identifier)
    }
    
    func testUserEscapeForRouteItem() {
        storage.currentUser = userD
        itemForIdentifier(targetIdentifier: userI.node.identifier) { item in
            guard let user = router.userEscapeForRouteItem(item: item) else {
                XCTFail()
                return
            }
            XCTAssertEqual(user, userG)
        }
    }
    
    func testUserTargetForRouteItem() {
        storage.currentUser = userD
        itemForIdentifier(targetIdentifier: userF.node.identifier) { item in
            guard let user = router.userTargetForRouteItem(item: item) else {
                XCTFail()
                return
            }
            XCTAssertEqual(user, userF)
        }
    }
    
    func testAddingNode() {
        storage.currentUser = userA
        storage.users.onNext([])

        guard let usersCount = try? storage.users.value().count else {
            XCTFail()
            return
        }
        XCTAssertEqual(usersCount, 0)


        let node = BTNode(name: "Node Name", identifier: "11111111-1111-1111-1111-111111111111")
        border.fireNewNode(node: node)

        guard let usersCountAfter = try? storage.users.value().count else {
            XCTFail()
            return
        }

        XCTAssertEqual(usersCountAfter, 1)

        guard let user = try? storage.users.value().first else {
            XCTFail()
            return
        }

        XCTAssertEqual(user?.node.identifier, "11111111-1111-1111-1111-111111111111")
    }
    
    func testReceivingMessage() {
        storage.currentUser = userB
        let expectation = XCTestExpectation(description: "Message receiving expectation")
        let message = BTMessage(text: "Test message :)", date: Date(), sender: userA, receiver: userB)
        
        router.rx_message.subscribe(onNext: { [weak self] message in
            XCTAssertEqual(message.receiver, self?.userB)
            XCTAssertEqual(message.sender, self?.userA)
            XCTAssertEqual(message.text, "Test message :)")
            expectation.fulfill()
        }).disposed(by: bag)
        
        border.fireNewMessage(message: message)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReceivingRouteUpdate() {
        storage.currentUser = userA

        let itemX = BTRouteItem(targetNodeIdentifier: "55555555-5555-5555-5555-555555555555",
                                escapeNodeIdentifier: "66666666-6666-6666-6666-666666666666",
                                targetRssi: -77,
                                escapeRssi: -66,
                                targetName: "Node X")
        
        guard let currentUser = storage.currentUser else {
            XCTFail()
            return
        }
        
        currentUser.node.visibleNodeItems.onNext([])
        border.fireNewRouteUpdate(items: [itemX])
        
        guard let visibleItems = try? currentUser.node.visibleNodeItems.value() else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(visibleItems.count, 1)
        
        guard let item = visibleItems.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(item.targetNodeIdentifier, "55555555-5555-5555-5555-555555555555")
        XCTAssertEqual(item.escapeNodeIdentifier, "66666666-6666-6666-6666-666666666666")
        XCTAssertEqual(item.targetRssi, -77)
        XCTAssertEqual(item.escapeRssi, -66)
        XCTAssertEqual(item.targetName, "Node X")
    }
}

// MARK: - Extensions

extension BTRouterTests {
    
    private func loadMeshNodes() {
        userA = UserFactory.generateUserA()
        userB = UserFactory.generateUserB()
        userC = UserFactory.generateUserC()
        userD = UserFactory.generateUserD()
        userE = UserFactory.generateUserE()
        userF = UserFactory.generateUserF()
        userG = UserFactory.generateUserG()
        userH = UserFactory.generateUserH()
        userI = UserFactory.generateUserI()
        
        storage.users.onNext([userA, userB, userC, userD, userE, userF, userG, userH, userI])
    }
    
    private func configRouter() {
        
        BTPeripheralManager.config = BTPeripheralManagerConfig(storage: storage)
        let peripheralManager = BTPeripheralManager.shared
        
        BTCentralManager.config = BTCentralManagerConfig(storage: storage)
        let centralManager = BTCentralManager.shared
        
        border = BorderMock(peripheralManager: peripheralManager,
                            centralManager: centralManager,
                            storage: storage)
        
        BTRouter.config = BTRouterConfig(border: border,
                                         storage: storage,
                                         service_ID: "55555555-5555-5555-5555-555555555555",
                                         identification_ID: "66666666-6666-6666-6666-666666666666",
                                         route_update_RX_ID: "77777777-7777-7777-7777-777777777777",
                                         message_RX_ID: "88888888-8888-8888-8888-888888888888")
        router = BTRouter()
    }
    
    private func itemForIdentifier(targetIdentifier: String, completion: (BTRouteItem) -> Void) {
        guard let items = try? storage.currentUser?.node.visibleNodeItems.value(), let visibleItems = items else {
            XCTFail()
            return
        }
        
        for item in visibleItems {
            if item.targetNodeIdentifier == targetIdentifier {
                completion(item)
            }
        }
    }
}

