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

let BTMESH_SERVICE_UUID: CBUUID = CBUUID(string: "06CD7CAA-CA1C-4C9A-9EC1-E60EDE7B3C2E")
let BTMESH_PAYLOAD: Int = 200
let BTMESH_MINIMUM_RSSI: Int = -127

struct BTServiceCharacteristics {
    
    struct Message_RX {
        static let UUID: CBUUID = CBUUID(string: "3B7C432B-5D97-4C82-BF45-B6B8C097EF9C")
        static let PROPERTIES: CBCharacteristicProperties = .write
        static let PERMISSIONS: CBAttributePermissions = .writeable
    }
    
    struct Identification {
        static let UUID: CBUUID = CBUUID(string: "4A4C566D-AAD3-47C8-A2C8-E8CD2BDDBCAF")
        static let PROPERTIES: CBCharacteristicProperties = .read
        static let PERMISSIONS: CBAttributePermissions = .readable
    }
    
    struct Route_update_RX {
        static let UUID: CBUUID = CBUUID(string: "7773C2AB-F128-40E2-BCE4-9D4F02101030")
        static let PROPERTIES: CBCharacteristicProperties = .write
        static let PERMISSIONS: CBAttributePermissions = .writeable
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
