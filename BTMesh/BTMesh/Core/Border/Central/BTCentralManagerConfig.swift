//
//  BTCentralManagerConfig.swift
//  BTMesh
//
//  Created by Marcos on 01/07/2018.
//  Copyright © 2018 Marcos Borges. All rights reserved.
//

import Foundation

// MARK: - Class

class BTCentralManagerConfig {
    
    // MARK: - Public properties
    
    var storage: BTStorageProtocol?
    
    // MARK: - Initialization
    
    public init(storage: BTStorageProtocol?) {
        self.storage = storage
    }
}
