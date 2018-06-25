//
//  BTCentralManager.swift
//  Wthere
//
//  Created by Marcos Borges on 16/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

// MARK: - Class

class BTCentralManager: NSObject {
    
    // MARK: - Public properties
    
    static let shared = BTCentralManager()
    var peripheralToRemove = PublishSubject<CBPeripheral>()
    var nodeToAdd = PublishSubject<BTNode>()
    var peripheralToUpdateRSSI = PublishSubject<(CBPeripheral, NSNumber)>()
    
    // MARK: - private properties
    
    private var manager: CBCentralManager!
    private var _discoveredPeripherals = BehaviorSubject<Set<CBPeripheral>>(value: [])
    private var currentState = BehaviorSubject<CBManagerState>(value: .unknown)
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
    
    private func processCharacteristic(characteristic: CBCharacteristic, for peripheral: CBPeripheral) {
        switch characteristic.uuid {
        case BTServiceCharacteristics.Identification.UUID:
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
        case BTServiceCharacteristics.Route_update_RX.UUID:
            break
        case BTServiceCharacteristics.Message_RX.UUID:
            break
        default:
            break
        }
    }
    
    private func updatedValue(for characteristic: CBCharacteristic, with peripheral: CBPeripheral) {
        guard let data = characteristic.value else { return }
        
        switch characteristic.uuid {
        case BTServiceCharacteristics.Identification.UUID:
            guard let node = BTSerialization.deserializeIdentification(data: data) else { return }
            node.updatePeripheral(peripheral: peripheral)
            debugPrint("Found new node: \(node.name)")
            
            // remove
//            guard node.name != "marcos" else { return }
            // remove
            
            nodeToAdd.onNext(node)
            peripheral.readRSSI()
        default:
            break
        }
    }
    
    // MARK: - Private methods
    
    private func discoveredPeripheralsContais(peripheral: CBPeripheral) -> Bool {
        guard let peripherals = try? _discoveredPeripherals.value() else { return false }
        return peripherals.contains(peripheral)
    }
    
    private func discoveredPeripheralsRemove(peripheral: CBPeripheral) {
        guard var peripherals = try? _discoveredPeripherals.value() else { return }
        peripherals.remove(peripheral)
        _discoveredPeripherals.onNext(peripherals)
    }
    
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
    
    private func cleanUp(peripheral: CBPeripheral) {
        guard let services = peripheral.services else { return }
        for service in services {
            
            guard let characteristics = service.characteristics else { continue }
            for characteristic in characteristics {
                
                let btmeshCharacteristicsIdentifiers = [BTServiceCharacteristics.Identification.UUID,
                                                        BTServiceCharacteristics.Route_update_RX.UUID,
                                                        BTServiceCharacteristics.Message_RX.UUID]
                if btmeshCharacteristicsIdentifiers.contains(characteristic.uuid) &&
                    characteristic.isNotifying {
                    
                    peripheral.setNotifyValue(false, for: characteristic)
                }
            }
        }
    }
}

// MARK: - Central Manager Delegate

extension BTCentralManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
        }
        
        currentState.onNext(central.state)
    }
 
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let identifier = peripheral.identifier
        debugPrint("Found -> Name: \(peripheral.name ?? "UNKNOWN NAME"), Identifier (Peripheral): \(identifier)")
        
        guard var peripherals = try? _discoveredPeripherals.value() else { return }
        peripherals.insert(peripheral)
        _discoveredPeripherals.onNext(peripherals)
        
        debugPrint("Trying to connect to peripheral....: \(peripheral)")
        manager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("---> Connected: \(peripheral.identifier)")
        peripheral.delegate = self
        peripheral.discoverServices([BTMESH_SERVICE_UUID])
        
        // to stop scan and save battery
//            self.manager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Fail to connect: \(peripheral.identifier), error: \(String(describing: error?.localizedDescription))")
        
        if discoveredPeripheralsContais(peripheral: peripheral) {
            peripheralToRemove.onNext(peripheral)
            discoveredPeripheralsRemove(peripheral: peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected: \(peripheral.identifier), error: \(String(describing: error?.localizedDescription))")
        
        cleanUp(peripheral: peripheral)
        
        if discoveredPeripheralsContais(peripheral: peripheral) {
            peripheralToRemove.onNext(peripheral)
            discoveredPeripheralsRemove(peripheral: peripheral)
        }
    }
}

// MARK: - Peripheral Delegate

extension BTCentralManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        debugPrint("Invalidated Services: \(invalidatedServices)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            debugPrint("Services ERROR: \(error)")
            return
        }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            
            guard service.uuid == BTMESH_SERVICE_UUID else { continue }
            debugPrint("Service found: \(service)")
            
            peripheral.discoverCharacteristics([BTServiceCharacteristics.Message_RX.UUID,
                                                BTServiceCharacteristics.Identification.UUID,
                                                BTServiceCharacteristics.Route_update_RX.UUID
                                                ], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            debugPrint("Characteristics ERROR: \(error)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            debugPrint("Characteristic found: \(characteristic)")
            processCharacteristic(characteristic: characteristic, for: peripheral)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            debugPrint("Characteristics NOTIFICATION ERROR: \(error)")
            return
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            debugPrint("Characteristic: \(characteristic.uuid) VALUE ERROR: \(error)")
            return
        }
        
        debugPrint("CHARACTERISTIC: \(characteristic.uuid) DID UPDATE, VALUE: \(String(describing: characteristic.value))")
        updatedValue(for: characteristic, with: peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let error = error {
            debugPrint("RSSI VALUE ERROR: \(error)")
            return
        }
        
        debugPrint("RSSI: \(RSSI), for peripheral: \(peripheral)")
        peripheralToUpdateRSSI.onNext((peripheral, RSSI))
    }
}


