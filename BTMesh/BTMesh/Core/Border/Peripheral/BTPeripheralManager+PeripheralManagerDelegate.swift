//
//  BTPeripheralManager+PeripheralManagerDelegate.swift
//  BTMesh
//
//  Created by Marcos Borges on 25/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

// MARK: - Peripheral Manager Delegate

extension BTPeripheralManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        switch peripheral.state {
        case .unknown:
            print("peripheral.state is .unknown")
            cleanUp()
        case .resetting:
            print("peripheral.state is .resetting")
        case .unsupported:
            print("peripheral.state is .unsupported")
        case .unauthorized:
            print("peripheral.state is .unauthorized")
        case .poweredOff:
            print("peripheral.state is .poweredOff")
            cleanUp()
        case .poweredOn:
            print("peripheral.state is .poweredOn")
            currentState.onNext(.poweredOn)
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        debugPrint("Advertising did start......: Error: \(String(describing: error?.localizedDescription))")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        for request in requests {
            
            guard let data = request.value else { continue }
            
            switch request.characteristic.uuid {
            case BTServiceCharacteristics.Message_RX.UUID:
                print("RECEIVED MESSAGE .... : \(data)")
                messageDidReceive(data: data)
            case BTServiceCharacteristics.Route_update_RX.UUID:
                //                print("RECEIVED ROUTE UPDATE .... : \(data)")
                routeUpdateDidReceive(data: data)
                
            default:
                break
            }
            
            manager.respond(to: request, withResult: .success)
        }
    }
}

// MARK: - Helpers

extension BTPeripheralManager {
    
    private func messageDidReceive(data: Data) {
        
        if let info = BTSerialization.deserializeMessage(data: data) {
            rxMessage(info: info)
        } else {
            if messageDataCache == nil {
                messageDataCache = Data()
            }
            messageDataCache?.append(data)
        }
        
        guard let cache = messageDataCache else { return }
        guard let info = BTSerialization.deserializeMessage(data: cache) else {
            return
        }
        
        messageDataCache = nil
        rxMessage(info: info)
    }
    
    private func rxMessage(info: (sender: BTNode, receiver: BTNode, message: String)) {
        let sender = User(node: info.sender)
        let receiver = User(node: info.receiver)
        let message = Message(text: info.message, date: Date(), sender: sender, receiver: receiver)
        rx_message.onNext(message)
    }
    
    private func routeUpdateDidReceive(data: Data) {
        
        if let info = BTSerialization.deserializeRouteInformation(data: data) {
            rxRouteInformation(node: info.node, items: info.items)
        } else {
            if routeDataCache == nil {
                routeDataCache = Data()
            }
            routeDataCache?.append(data)
        }
        
        guard let cache = routeDataCache else { return }
        guard let info = BTSerialization.deserializeRouteInformation(data: cache) else {
            return
        }
        
        routeDataCache = nil
        rxRouteInformation(node: info.node, items: info.items)
    }
    
    private func rxRouteInformation(node: BTNode, items: [BTRouteItem]) {
        
        guard let currentVisibleItems = try? Storage.shared.currentUser?.node.visibleNodeItems.value() else { return }
        guard let visibleItems = currentVisibleItems else { return }
        var modifiedItems: [BTRouteItem] = []
        
        for item in items {
            item.escapeNodeIdentifier = node.identifier
            item.targetRssi = item.targetRssi + item.escapeRssi
            item.escapeRssi = node.RSSI
            
            if  item.targetNodeIdentifier != Storage.shared.currentUser?.node.identifier &&
                item.targetNodeIdentifier != item.escapeNodeIdentifier {
                
                if let existingItem = itemForTargetIdentifier(identifier: item.targetNodeIdentifier, items: visibleItems) {
                    if item.targetRssi > existingItem.targetRssi {
                        existingItem.targetName = item.targetName
                        existingItem.targetNodeIdentifier = item.targetNodeIdentifier
                        existingItem.targetRssi = item.targetRssi
                        existingItem.escapeNodeIdentifier = item.escapeNodeIdentifier
                        existingItem.escapeRssi = item.escapeRssi
                        // VERIFY if this WORKS! ==================== ------ ====== ------ ====== ------
                    }
                } else {
                    
                    if !(visibleItems.contains(item)) {
                        let newNode = BTNode(name: item.targetName, identifier: item.targetNodeIdentifier)
                        newNode.RSSI = BTMESH_MINIMUM_RSSI
                        nodeToAdd.onNext(newNode)
                        
                        modifiedItems.append(item)
                    }
                }
            }
        }
        
        rx_routeInformation.onNext(modifiedItems) // only NEW items
    }
    
    private func itemShouldBeUpdated(item: BTRouteItem) -> Bool {
        return false
    }
    
    private func itemForTargetIdentifier(identifier: String, items: [BTRouteItem]) -> BTRouteItem? {
        for item in items {
            if item.targetNodeIdentifier == identifier {
                return item
            }
        }
        return nil
    }
    
    private func cleanUp() {
        manager.removeAllServices()
        stopAdvertising()
    }
}

