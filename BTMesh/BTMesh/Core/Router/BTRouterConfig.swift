//
//  BTRouterConfig.swift
//  BTMesh
//
//  Created by Marcos Borges on 26/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import CoreBluetooth

// MARK: - Class

public class BTRouterConfig {
    
    // MARK: - Public properties
    
    var border: BTBorderProtocol?
    var storage: BTStorageProtocol?
    var service_ID: String?
    var message_RX_ID: String?
    var identification_ID: String?
    var route_update_RX_ID: String?
    
    // MARK: - Initialization
    
    public init(border: BTBorderProtocol? = nil,
                storage: BTStorageProtocol? = BTStorage.shared,
                service_ID: String? = nil,
                identification_ID: String? = nil,
                route_update_RX_ID: String? = nil,
                message_RX_ID: String? = nil) {
        
        if border == nil, let storage = storage {
            BTCentralManager.config = BTCentralManagerConfig(storage: storage)
            BTPeripheralManager.config = BTPeripheralManagerConfig(storage: storage)
            
            self.border = BTBorder(peripheralManager: BTPeripheralManager.shared,
                                   centralManager: BTCentralManager.shared,
                                   storage: storage)
        } else {
            self.border = border
        }
        
        self.storage = storage
        self.service_ID = service_ID
        self.message_RX_ID = message_RX_ID
        self.identification_ID = identification_ID
        self.route_update_RX_ID = route_update_RX_ID
    }
}
