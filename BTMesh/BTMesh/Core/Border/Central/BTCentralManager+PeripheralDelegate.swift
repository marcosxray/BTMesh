//
//  BTCentralManager+PeripheralDelegate.swift
//  BTMesh
//
//  Created by Marcos Borges on 25/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

// MARK: - Peripheral Delegate

extension BTCentralManager: CBPeripheralDelegate {
    
    // MARK: - Internal methods
    
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

// MARK: - Helpers

extension BTCentralManager {
    
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
}
