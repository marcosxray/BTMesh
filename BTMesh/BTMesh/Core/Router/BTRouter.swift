//
//  BTRouter.swift
//  BTMesh
//
//  Created by Marcos Borges on 03/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import RxSwift
import CoreBluetooth

// MARK: - Class

public class BTRouter {
    
    // MARK: - Public properties
    
    public static let shared = BTRouter()
    public static var config = BTRouterConfig()
    
    public var rx_message: Observable<BTMessage> {
        return _rx_message.asObservable()
    }
    
    // MARK: - Private properties
    
    private var bag = DisposeBag()
    private let border: BTBorderProtocol
    private let storage: BTStorageProtocol
    private var _rx_message = PublishSubject<BTMessage>()
    
    // MARK: - initialization
    
    init() {
        guard   let border = BTRouter.config.border,
                let storage = BTRouter.config.storage,
                let service_ID = BTRouter.config.service_ID,
                let message_RX_ID = BTRouter.config.message_RX_ID,
                let identification_ID = BTRouter.config.identification_ID,
                let route_update_RX_ID = BTRouter.config.route_update_RX_ID else {
                fatalError("You MUST call config before accessing BTRouter!")
        }
        
        self.border = border
        self.storage = storage
        BTServiceProperties.BTMESH_SERVICE_UUID = CBUUID(string: service_ID)
        BTServiceProperties.Characteristics.Message_RX.UUID = CBUUID(string: message_RX_ID)
        BTServiceProperties.Characteristics.Identification.UUID = CBUUID(string: identification_ID)
        BTServiceProperties.Characteristics.Route_update_RX.UUID = CBUUID(string: route_update_RX_ID)
        
        setupRx()
    }
    
    // MARK: - Public methods
    
    public func start() {
        border.start()
    }
        
    public func sendMessage(message: BTMessage) {
        
        guard let currentUser = storage.currentUser else { return }
        guard let visibleItems = try? currentUser.node.visibleNodeItems.value() else { return }
        
        for item in visibleItems {
            if item.targetNodeIdentifier == message.receiver.node.identifier {
                if let user = userEscapeForRouteItem(item: item) {
                    border.sendMessage(message: message, escapeNode: user.node)
                    return
                }
            }
        }
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
        border.rx_message.subscribe(onNext: { [weak self] message in
            guard let weakSelf = self else { return }
            
            if message.receiver.node.identifier == weakSelf.storage.currentUser?.node.identifier {
                weakSelf._rx_message.onNext(message)
            } else {
                weakSelf.addStampAndResend(message)
            }
            
            debugPrint("---------------------------------------------------")
            debugPrint("Message received from: \(message.sender.name)")
            debugPrint("To: \(message.receiver.name)")
            debugPrint("Message: \(message.text)")
            debugPrint("---------------------------------------------------")
        }).disposed(by: bag)

        //
        guard let currentUser = storage.currentUser else { return }
        currentUser.node.visibleNodeItems.asObservable().subscribe(onNext: { items in
            debugPrint("Current visible nodes: -------------------")
            for item in items {
                debugPrint("\(item.asDictionary())")
            }
            debugPrint("------------------------------------------")
        }).disposed(by: bag)
    }
    
    private func addStampAndResend(_ message: (BTMessage)) {
        let stampedText = message.text + " (routed by \(storage.currentUser?.name ?? "-"))"
        let stampedMessage = BTMessage(text: stampedText,
                                       date: message.date,
                                       sender: message.sender,
                                       receiver: message.receiver)
        sendMessage(message: stampedMessage)
    }
    
    private func addUserWith(node: BTNode) {
        guard   let currentUser = storage.currentUser,
                let subItems = try? node.visibleNodeItems.value() else { return }
        
        let user = BTUser(node: node)
        storage.addUser(user: user)
        
        // add the node itself here
        guard node.RSSI != BTServiceProperties.BTMESH_MINIMUM_RSSI else { return }
        
        let routeItem = BTRouteItem(targetNodeIdentifier: node.identifier,
                                    escapeNodeIdentifier: currentUser.node.identifier,
                                    targetRssi: node.RSSI,
                                    escapeRssi: node.RSSI,
                                    targetName: node.name)
        
        currentUser.node.addVisibleNodeItem(item: routeItem)
        addSubItems(subItems, currentUser)
        debugPrint("Storage added: \(user.name), RSSI: \(node.RSSI)")
    }
    
    private func addSubItems(_ subItems: [BTRouteItem], _ currentUser: BTUser) {
        for item in subItems {
            if newItemShouldBeAdded(item: item) {
                currentUser.node.addVisibleNodeItem(item: item)
            }
        }
    }

    
    // ******************** to do
    private func newItemShouldBeAdded(item: BTRouteItem) -> Bool { // or updated
//        guard let currentUser = storage.currentUser, let currentItems = try? currentUser.node.visibleNodeItems.value() else { return false }
//        
//        for currentItem in currentItems {
//            guard item.targetNodeIdentifier == currentItem.targetNodeIdentifier else { continue }
//            if item.targetRssi > currentItem.targetRssi
//        }
        return true
    }
    // ********************
    
    private func removeUserWith(node: BTNode) {
        let users = (try? storage.users.value()) ?? []
        for user in users {
            guard user.node.identifier == node.identifier else { continue }
            
            storage.removeUser(user: user)
            debugPrint("Storage removed: \(user.name)")

            removeVisibleItemsThrough(node: user.node)
        }
    }
    
    private func removeVisibleItemsThrough(node: BTNode) {
        guard let currentUser = storage.currentUser else { return }
        guard let visibleItems = try? currentUser.node.visibleNodeItems.value() else { return }
        var newItems: [BTRouteItem] = []
        
        for item in visibleItems {
            if  item.escapeNodeIdentifier != node.identifier &&
                item.targetNodeIdentifier != node.identifier {
                
                newItems.append(item)
            } else {
                if let user = userTargetForRouteItem(item: item) {
                    storage.removeUser(user: user)
                    debugPrint("Storage removed: \(user.name)")
                }
            }
        }
        
        border.callForRssiUpdate()
        currentUser.node.visibleNodeItems.onNext(newItems)
    }
    
    // todo
    // verify if a node goes down, what happens?
    private func updateUserVisibleNodes(items: [BTRouteItem]) {
        guard let currentUser = storage.currentUser else { return }
        guard var visibleItems = try? currentUser.node.visibleNodeItems.value() else { return }
        var newItems: [BTRouteItem] = []
        
        for item in items {
            if !(visibleItems.contains(item)) {
                newItems.append(item)
            }
        }
        
        guard newItems.count > 0 else { return }
        visibleItems.append(contentsOf: newItems)

        border.callForRssiUpdate()
        currentUser.node.visibleNodeItems.onNext(visibleItems)
    }
    
    // todo
    private func updateUserRssiFor(node: BTNode, RSSI: NSNumber) {
        node.RSSI = RSSI.intValue
        debugPrint("Updated RSSI: \(RSSI) for node: \(node.identifier)")
        
        guard let currentUser = storage.currentUser else { return }
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

// MARK: - Extensions - Routing

extension BTRouter {
    func escapeForUser(user: BTUser) -> BTUser? {
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
    
    func userEscapeForRouteItem(item: BTRouteItem) -> BTUser? {
        guard let users = try? storage.users.value() else { return nil }
        for user in users {
            if user.node.identifier == item.escapeNodeIdentifier {
                return user
            }
            
            if storage.currentUser?.node.identifier == item.escapeNodeIdentifier {
                return storage.currentUser
            }
        }
        return nil
    }
    
    func userTargetForRouteItem(item: BTRouteItem) -> BTUser? {
        guard let users = try? storage.users.value() else { return nil }
        for user in users {
            if user.node.identifier == item.targetNodeIdentifier {
                return user
            }
        }
        return nil
    }
}


