//
//  BTIdentifier.swift
//  Wthere
//
//  Created by Marcos Borges on 01/06/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import UIKit
import CoreBluetooth

// MARK: - Class

struct BTIdentifier {
    
    // MARK: - Public methods
    
    static func getDeviceId() -> String {
        guard let idString = UIDevice.current.identifierForVendor?.uuidString else { return "" }
        debugPrint(">>>> DEVICE IDENTIFIER: \(idString)")
        return idString
    }
    
    static func nodeForPeripheralIdentifier(identifier: UUID) -> BTNode? {
        let users = (try? Storage.shared.users.value()) ?? []
        for user in users {
            guard let peripheralId = user.node.peripheralId else { continue }
            if identifier == peripheralId {
                return user.node
            }
        }
        
        return nil
    }
}
