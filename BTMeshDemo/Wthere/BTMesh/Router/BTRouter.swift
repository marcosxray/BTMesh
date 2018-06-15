//
//  BTRouter.swift
//  Wthere
//
//  Created by Marcos Borges on 03/06/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation
import RxSwift
import CoreBluetooth

// MARK: - Class

class BTRouter {
    
    // MARK: - Public properties
    
    var rx_message: Observable<Message> {
        return border.rx_message
    }
    
    // MARK: - Private properties
    
    private var bag = DisposeBag()
    private let border: BTBorderProtocol
    private let storage: StorageProtocol
    
    // MARK: - initialization
    
    init(border: BTBorderProtocol, storage: StorageProtocol) {
        self.border = border
        self.storage = storage
        setupRx()
    }
    
    // MARK: - Public methods
    
    func start() {
        border.start()
    }
    
    func sendMessageToAllUsers(message: Message) {
        border.sendMessageToAllUsers(message: message)
    }
    
    func sendMessageToUser(message: Message, user: User) {
        sendMessageToUser(message: message, user: user)
    }
    
    // MARK: - Private methods
    
    private func setupRx() {
        border.nodeToAdd.subscribe(onNext: { [weak self] node in
            self?.addUserWith(node: node)
        }).disposed(by: bag)
        
        //
        border.nodeToRemove.subscribe(onNext: { [weak self] node in
            self?.removeUserWith(node: node)
        }).disposed(by: bag)
        
        //
        border.nodeToUpdateRSSI.subscribe(onNext: { [weak self] (node, RSSI) in
            self?.updateUserRssiFor(node: node, RSSI: RSSI)
        }).disposed(by: bag)

        //
        border.rx_routeInformation.subscribe(onNext: { [weak self] items in
            self?.updateUserVisibleNodes(items: items)
        }).disposed(by: bag)
        
        //
        guard let currentUser = Storage.shared.currentUser else { return }
        currentUser.node.visibleNodeItems.asObservable().subscribe(onNext: { items in
            debugPrint("Current visible nodes: -------------------")
            for item in items {
                debugPrint("\(item.asDictionary())")
            }
            debugPrint("------------------------------------------")
        }).disposed(by: bag)
    }
    
    private func addUserWith(node: BTNode) {
        
        guard let currentUser = Storage.shared.currentUser, let items = try? node.visibleNodeItems.value() else { return }
        let user = User(node: node)
        Storage.shared.addUser(user: user)
        
        // add the node itself here
        if node.RSSI != BTMESH_MINIMUM_RSSI {
            let routeItem = BTRouteItem(targetNodeIdentifier: node.identifier, escapeNodeIdentifier: currentUser.node.identifier, targetRssi: node.RSSI, escapeRssi: node.RSSI, targetName: node.name)
            print(node.RSSI)
            currentUser.node.addVisibleNodeItem(item: routeItem)
        }
        
         // add node's sub items
        for item in items {
            currentUser.node.addVisibleNodeItem(item: item)
        }
        debugPrint("Storage added: \(user.name)")
    }
        
    private func removeUserWith(node: BTNode) {
        let users = (try? Storage.shared.users.value()) ?? []
        for user in users {
            guard user.node.identifier == node.identifier else { return }
            Storage.shared.removeUser(user: user)
            debugPrint("Storage removed: \(user.name)")
        }
    }

    private func updateUserVisibleNodes(items: [BTRouteItem]) {
        guard let currentUser = Storage.shared.currentUser else { return }
        guard var visibleItems = try? currentUser.node.visibleNodeItems.value() else { return }
        var newItems: [BTRouteItem] = []
        
        for item in items {
            if !(visibleItems.contains(item)) {
                newItems.append(item)
            }
        }
        
        guard newItems.count > 0 else { return }
        visibleItems.append(contentsOf: items)
        
        border.callForRssiUpdate()
        currentUser.node.visibleNodeItems.onNext(visibleItems)
    }

    private func updateUserRssiFor(node: BTNode, RSSI: NSNumber) {
        node.RSSI = RSSI.intValue
        debugPrint("Updated RSSI: \(RSSI) for node: \(node.identifier)")
        
        guard let currentUser = Storage.shared.currentUser else { return }
        guard let visibleItems = try? currentUser.node.visibleNodeItems.value() else { return }
        
        var hasChanges: Bool = false
        for item in visibleItems {
            
            if node.identifier == item.escapeNodeIdentifier {
                item.escapeRssi = RSSI.intValue
                hasChanges = true
            }
            
            if node.identifier == item.targetNodeIdentifier {
                item.targetRssi = RSSI.intValue
                hasChanges = true
            }
        }
        
        if hasChanges {
            currentUser.node.visibleNodeItems.onNext(visibleItems)
        }
    }
}

// MARK: - Extensions - routing

extension BTRouter {
    func escapeForUser(user: User) -> User? {
        guard let item = routeItemForNode(node: user.node) else { return nil }
        return userEscapeForRouteItem(item: item)
    }
    
    func routeItemForNode(node: BTNode) -> BTRouteItem? {
        guard let visibleItems = try? storage.currentUser?.node.visibleNodeItems.value() else { return nil }
        guard let items = visibleItems else { return nil }
        
        for item in items {
            if item.targetNodeIdentifier == node.identifier {
                return item
            }
        }
        return nil
    }
    
    func userEscapeForRouteItem(item: BTRouteItem) -> User? {
        guard let users = try? storage.users.value() else { return nil }
        for user in users {
            if user.node.identifier == item.escapeNodeIdentifier {
                return user
            }
        }
        return nil
    }
}


