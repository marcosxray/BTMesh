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

//// MARK: - Definitions
//
//class BTRssiItem: Equatable, Hashable {
//
//    var peripheralIdentifier: UUID
//    var rssi: NSNumber
//
//    var hashValue: Int {
//        return peripheralIdentifier.hashValue
//    }
//
//    init(peripheralIdentifier: UUID, rssi: NSNumber) {
//        self.peripheralIdentifier = peripheralIdentifier
//        self.rssi = rssi
//    }
//
//    static func == (lhs: BTRssiItem, rhs: BTRssiItem) -> Bool {
//        return lhs.peripheralIdentifier == rhs.peripheralIdentifier
//    }
//}

// MARK: - Class

class BTCentralManager: NSObject {
    
    // MARK: - Public properties
    
    static let shared = BTCentralManager()
    var peripheralToRemove = PublishSubject<CBPeripheral>()
    var nodeToAdd = PublishSubject<BTNode>()
    var peripheralToUpdateRSSI = PublishSubject<(CBPeripheral, NSNumber)>()
//    var peripheralToUpdateRouteItems = PublishSubject<(CBPeripheral, [BTRouteItem])>()
//    var rssiList: Set<BTRssiItem> = []
    
    // MARK: - private properties
    
    private var manager: CBCentralManager!
    private var _discoveredPeripherals = BehaviorSubject<Set<CBPeripheral>>(value: [])
    private var currentState = BehaviorSubject<CBManagerState>(value: .unknown)
    private var bag = DisposeBag()
//    private var dataCache: Data?
    
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
    
//    func sendMessage(user: User, message: Message) {
//        guard let peripherals = try? _discoveredPeripherals.value() else { return }
//        for peripheral in peripherals {
//            guard peripheral.identifier == user.node.peripheralId else { continue }
//            writeMessage(peripheral: peripheral, message: message)
//        }
//    }
    
    func callForRssiUpdate() {
        guard let peripherals = try? _discoveredPeripherals.value() else { return }
        for peripheral in peripherals {
            peripheral.readRSSI()
        }
    }
    
    func sendMessageToAllUsers(message: Message) {
        guard let peripherals = try? _discoveredPeripherals.value() else { return }
        for peripheral in peripherals {
            writeMessage(peripheral: peripheral, message: message)
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
//        case BTServiceCharacteristics.Route_notification.UUID:
//            if characteristic.properties.contains(.notify) {
//                peripheral.setNotifyValue(true, for: characteristic)
//            }
//        case BTServiceCharacteristics.Route_update.UUID:
//            if characteristic.properties.contains(.read) {
//                peripheral.readValue(for: characteristic)
//            }
//            break
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
            nodeToAdd.onNext(node)
            peripheral.readRSSI()
        default:
            break
        }
    }
    
//    func processVisibleItems(peripheral: CBPeripheral, nodeVisibleItems: [BTRouteItem]) {
//        peripheralToUpdateRouteItems.onNext((peripheral, nodeVisibleItems))
//        
//        print("PERIPHERAL: \(peripheral)")
//        for item in nodeVisibleItems {
//            print("VISIBLE ITEM: \(item.asDictionary())")
//        }
//    }
    
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
    
    //--------------------------------------------------------
    private func writeMessage(peripheral: CBPeripheral, message: Message) {
        
        guard let data = BTSerialization.serializeMessage(node: message.sender.node, message: message.text) else { return }
        guard let characteristic = getCharacteristic(peripheral: peripheral, serviceId: BTMESH_SERVICE_UUID, characteristicId: BTServiceCharacteristics.Message_RX.UUID) else { return }
        guard characteristic.properties.contains(.write) else { return }
        
        writeDataOnCharacteristic(data: data, peripheral: peripheral, characteristic: characteristic)
    }
    //--------------------------------------------------------
    //----------------------------------------------------------------------------
    
    private func writeVisibleNodesList(peripheral: CBPeripheral, items: [BTRouteItem]) {
        
        guard items.count > 0 else { return }
        
        /// fake data ///
//        var items2: [BTRouteItem] = []
//        let item1 = BTRouteItem(targetNodeIdentifier: "lala1", escapeNodeIdentifier: "eu mesmo", targetRssi: -1, escapeRssi: -1, targetName: "Chumbalumba")
//        let item2 = BTRouteItem(targetNodeIdentifier: "lala2", escapeNodeIdentifier: "hahaha", targetRssi: -1, escapeRssi: -1, targetName: "ElCamilo")
//        let item3 = BTRouteItem(targetNodeIdentifier: "lala3", escapeNodeIdentifier: "mais um ", targetRssi: -1, escapeRssi: -1, targetName: "Tim Maia")
//        items2.append(contentsOf: [item1, item2, item3])
        /// fake data ///
        
        // chunk !!!!!!!!!!!!!!!!!!!!!!!!!!!!
//        guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier) else { return }
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
    
    //----------------------------------------------------------------------------
    
//    private func rssiForPeripheral(peripheral: CBPeripheral) -> Int? {
//        for item in rssiList {
//            if item.peripheralIdentifier == peripheral.identifier {
//                return item.rssi.intValue
//            }
//        }
//        return nil
//    }
    
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
            
            guard let characteristics = service.characteristics else { return }
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
        
//        let rssiItem = BTRssiItem(peripheralIdentifier: identifier, rssi: RSSI)
//        rssiList.insert(rssiItem)
        
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
        debugPrint("***************************** invalidatedServices: \(invalidatedServices)")
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
    
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            debugPrint("DID Write value: \(String(describing: characteristic.value)), error: \(error)")
//            return
//        }
//    }
}


