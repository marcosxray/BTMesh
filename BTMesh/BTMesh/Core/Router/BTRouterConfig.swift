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
    var border: BTBorderProtocol?
    var storage: BTStorageProtocol?
    
    var service_ID: String?
    var message_RX_ID: String?
    var identification_ID: String?
    var route_update_RX_ID: String?
    
    public init(service_ID: String? = nil,
                identification_ID: String? = nil,
                route_update_RX_ID: String? = nil,
                message_RX_ID: String? = nil) {
        
        self.border = BTBorder()
        self.storage = BTStorage.shared
        
        self.service_ID = service_ID
        self.message_RX_ID = message_RX_ID
        self.identification_ID = identification_ID
        self.route_update_RX_ID = route_update_RX_ID
    }
}
