//
//  BTCentralManager.swift
//  BTMesh
//
//  Created by Marcos Borges on 16/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

// MARK: - Class

class BTCentralManager: NSObject {
    
    // MARK: - Internal properties
    
    static let shared = BTCentralManager()
    var peripheralToRemove = PublishSubject<CBPeripheral>()
    var nodeToAdd = PublishSubject<BTNode>()
    var peripheralToUpdateRSSI = PublishSubject<(CBPeripheral, NSNumber)>()
    
    // MARK: - private properties
    
    internal var manager: CBCentralManager!
    internal var _discoveredPeripherals = BehaviorSubject<Set<CBPeripheral>>(value: [])
    internal var currentState = BehaviorSubject<CBManagerState>(value: .unknown)
    
    private var bag = DisposeBag()
    
    // MARK: - Initialization
    
    override private init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    // MARK: - Public methods
    
    func startScanning() {
        currentState.asObservable().filter{ $0 == .poweredOn }.subscribe(onNext: { [weak self] status in
            self?.manager.scanForPeripherals(withServices: [BTMESH_SERVICE_UUID], options: nil)
            debugPrint("Bluetooth powered on, scanning for peripherals.")
        }).disposed(by: bag)
    }
    
    func stopScanning() {
        self.manager.stopScan()
    }
}

// MARK: - Extensions

extension BTCentralManager {
    
    // MARK: - Public methods
    
    func sendMessage(message: Message, escapeNode: BTNode) {
        guard let peripherals = try? _discoveredPeripherals.value() else { return }
        for peripheral in peripherals {
            guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier) else { continue }
            
            if  escapeNode.identifier == Storage.shared.currentUser?.node.identifier &&
                message.receiver.node.identifier == node.identifier {
                writeMessage(peripheral: peripheral, message: message)
                continue
            }
            
            guard node.identifier == escapeNode.identifier else { continue }
            writeMessage(peripheral: peripheral, message: message)
        }
    }
    
    func callForRssiUpdate() {
        guard let peripherals = try? _discoveredPeripherals.value() else { return }
        for peripheral in peripherals {
            peripheral.readRSSI()
        }
    }
    
    func sendVisibleNodesListToAllUsers(items: [BTRouteItem]) {
        guard let peripherals = try? _discoveredPeripherals.value() else { return }
        for peripheral in peripherals {
            writeVisibleNodesList(peripheral: peripheral, items: items)
        }
    }

    // MARK: - Private methods
    
    private func writeMessage(peripheral: CBPeripheral, message: Message) {
        guard let data = BTSerialization.serializeMessage(sender: message.sender.node,
                                                          receiver: message.receiver.node,
                                                          message: message.text) else { return }
        
        guard let characteristic = getCharacteristic(peripheral: peripheral, serviceId: BTMESH_SERVICE_UUID, characteristicId: BTServiceCharacteristics.Message_RX.UUID) else { return }
        guard characteristic.properties.contains(.write) else { return }
        writeDataOnCharacteristic(data: data, peripheral: peripheral, characteristic: characteristic)
    }
    
    private func writeVisibleNodesList(peripheral: CBPeripheral, items: [BTRouteItem]) {
        
        guard items.count > 0 else { return }
        guard let node = Storage.shared.currentUser?.node else { return }
        
        guard let data = BTSerialization.serializeRouteInformation(node: node, items: items) else { return }
        guard let characteristic = getCharacteristic(peripheral: peripheral, serviceId: BTMESH_SERVICE_UUID, characteristicId: BTServiceCharacteristics.Route_update_RX.UUID) else { return }
        guard characteristic.properties.contains(.write) else { return }
        
        writeDataOnCharacteristic(data: data, peripheral: peripheral, characteristic: characteristic)
    }
    
    private func writeDataOnCharacteristic(data: Data, peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        
        let length = data.count
        let chunkSize = BTMESH_PAYLOAD
        var offset = 0
        
        repeat {
            let thisChunkSize = ((length - offset) > chunkSize) ? chunkSize : (length - offset);
            let chunk = data.subdata(in: offset..<offset + thisChunkSize )
            peripheral.writeValue(chunk, for: characteristic, type: .withResponse)
            offset += thisChunkSize;
        } while (offset < length);
    }
    
    private func getCharacteristic(peripheral: CBPeripheral, serviceId: CBUUID, characteristicId: CBUUID) -> CBCharacteristic? {
        guard peripheral.state == .connected, let services = peripheral.services else { return nil }
        for service in services {
            guard service.uuid == serviceId, let characteristics = service.characteristics else { return nil }
            for characteristic in characteristics {
                if characteristic.uuid == characteristicId {
                    return characteristic
                }
            }
        }
        return nil
    }
}


