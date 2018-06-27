//
//  BTRouterConfig.swift
//  BTMesh
//
//  Created by Marcos Borges on 26/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation

// MARK: - Class

public class BTRouterConfig {
    var border: BTBorderProtocol?
    var storage: StorageProtocol?
    
    public init(border: BTBorderProtocol? = nil, storage: StorageProtocol? = nil) {
        self.border = border
        self.storage = storage
    }
}
