//
//  BTIdentifier.swift
//  BTMesh
//
//  Created by Marcos Borges on 01/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import UIKit
import CoreBluetooth

// MARK: - Class

public struct BTIdentifier {
    
    // MARK: - Public methods
    
    public static func getDeviceId() -> String {
        guard let idString = UIDevice.current.identifierForVendor?.uuidString else { return "" }
        debugPrint(">>>> DEVICE IDENTIFIER: \(idString)")
        return idString
    }
    
    // MARK: - Internal methods
    
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
