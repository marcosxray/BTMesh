//
//  BTCentralManager+CentralManagerDelegate.swift
//  Wthere
//
//  Created by Marcos Borges on 25/06/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

// MARK: - Central Manager Delegate

extension BTCentralManager: CBCentralManagerDelegate {
    
    // MARK: - Public methods
    
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

// MARK: - Helpers

extension BTCentralManager {
    
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
