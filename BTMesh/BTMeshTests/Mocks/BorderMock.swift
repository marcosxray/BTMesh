//
//  BorderMocks.swift
//  BTMeshTests
//
//  Created by Marcos on 01/07/2018.
//  Copyright © 2018 Marcos Borges. All rights reserved.
//

import Foundation
import RxSwift
@testable import BTMesh

// MARK: - Class

class BorderMock: BTBorderProtocol {

    // MARK: - Public properties
    
    func fireNewNode(node: BTNode) {
        _nodeToAddForTesting.onNext(node)
    }
    
    func fireNewMessage(message: BTMessage) {
        _messageToReceiveForTesting.onNext(message)
    }
    
    func fireNewRouteUpdate(items: [BTRouteItem]) {
        _routeInfoToReceiveForTesting.onNext(items)
    }
    
    var rx_message: Observable<BTMessage> {
        return _messageToReceiveForTesting.asObservable()
    }
    
    var rx_routeInformation: Observable<[BTRouteItem]> {
        return _routeInfoToReceiveForTesting.asObservable()
    }
    
    var nodeToAdd: Observable<BTNode> {
        return _nodeToAddForTesting.asObservable()
    }
    
    var nodeToRemove: PublishSubject<BTNode> = PublishSubject<BTNode>()
    var nodeToUpdateRSSI = PublishSubject<(BTNode, NSNumber)>()
    
    // MARK: - Private properties
    
    private var _nodeToAddForTesting = PublishSubject<BTNode>()
    private var _messageToReceiveForTesting = PublishSubject<BTMessage>()
    private var _routeInfoToReceiveForTesting = PublishSubject<[BTRouteItem]>()
    
    // MARK: - Initialization
    
    required init(peripheralManager: BTPeripheralManager, centralManager: BTCentralManager, storage: BTStorageProtocol) {}
    
    // MARK: - Public methods
    
    func start() {}
    func sendMessage(message: BTMessage, escapeNode: BTNode) {}
    func callForRssiUpdate() {}
}


