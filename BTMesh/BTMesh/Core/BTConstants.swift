//
//  BTConstants.swift
//  BTMesh
//
//  Created by Marcos Borges on 16/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import CoreBluetooth

// MARK: - Definitions

struct BTServiceProperties {
    static var BTMESH_SERVICE_UUID: CBUUID = CBUUID(string: "00000000-0000-0000-0000-000000000000")
    static var BTMESH_PAYLOAD: Int = 200
    static let BTMESH_MINIMUM_RSSI: Int = -127
    
    struct Characteristics {
        struct Message_RX {
            static var UUID: CBUUID = CBUUID(string: "00000000-0000-0000-0000-000000000000")
            static let PROPERTIES: CBCharacteristicProperties = .write
            static let PERMISSIONS: CBAttributePermissions = .writeable
        }
        
        struct Identification {
            static var UUID: CBUUID = CBUUID(string: "00000000-0000-0000-0000-000000000000")
            static let PROPERTIES: CBCharacteristicProperties = .read
            static let PERMISSIONS: CBAttributePermissions = .readable
        }
        
        struct Route_update_RX {
            static var UUID: CBUUID = CBUUID(string: "00000000-0000-0000-0000-000000000000")
            static let PROPERTIES: CBCharacteristicProperties = .write
            static let PERMISSIONS: CBAttributePermissions = .writeable
        }
    }
}

enum BTManagerState {
    case unknown
    case resetting
    case unsupported
    case unauthorized
    case poweredOff
    case poweredOn
}

struct BTKeys {
    static let NODE_NAME = "NAME"
    static let NODE_IDENTIFIER = "IDENTIFIER"
    static let NODE_KEY = "NODE_KEY"
    
    static let MESSAGE_SENDER_NODE_KEY = "MESSAGE_SENDER_NODE_KEY"
    static let MESSAGE_RECEIVER_NODE_KEY = "MESSAGE_RECEIVER_NODE_KEY"
    static let MESSAGE_KEY = "MESSAGE_KEY"
    
    static let TARGET_NODE_KEY = "TARGET_NODE_KEY"
    static let TARGET_RSSI_KEY = "TARGET_RSSI_KEY"
    static let ESCAPE_NODE_KEY = "ESCAPE_NODE_KEY"
    static let ESCAPE_RSSI_KEY = "ESCAPE_RSSI_KEY"
    static let TARGET_NAME_KEY = "TARGET_NAME_KEY"
    
    
    static let ROUTE_ITEMS_KEY = "ROUTE_ITEMS_KEY"
}
