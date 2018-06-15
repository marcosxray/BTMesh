//
//  BTBorder.swift
//  BTMesh
//
//  Created by Marcos Borges on 10/03/2018.
//  Copyright © 2018 Marcos Borges. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

enum BTManagerState {
    case unknown
    case resetting
    case unsupported
    case unauthorized
    case poweredOff
    case poweredOn
}

public class BTBorder: NSObject {
    
    var centralManager: CBCentralManager!
    var centraManagerState: BTManagerState = .unknown
    
    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public func start() {
        guard centraManagerState == .poweredOn else {
            // throw error
            print("An error has ocurred !!!")
            return
        }
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
}

extension BTBorder: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
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
            centraManagerState = .poweredOn
        }
    }
}
