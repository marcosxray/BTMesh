//
//  BTRouteItem.swift
//  BTMesh
//
//  Created by Marcos Borges on 06/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation

// MARK: - Class

public class BTRouteItem {
    
    // MARK: - Public properties
    
    var targetNodeIdentifier: String
    var targetRssi: Int
    var targetName: String
    
    var escapeNodeIdentifier: String
    var escapeRssi: Int
    
    // MARK: - Initialization
    
    init(targetNodeIdentifier: String, escapeNodeIdentifier: String, targetRssi: Int, escapeRssi: Int, targetName: String) {
        self.targetNodeIdentifier = targetNodeIdentifier
        self.escapeNodeIdentifier = escapeNodeIdentifier
        self.targetRssi = targetRssi
        self.escapeRssi = escapeRssi
        self.targetName = targetName
    }
    
    init?(dictionary: [String: Any]) {
        guard let targetNodeIdentifier = dictionary[BTKeys.TARGET_NODE_KEY] as? String else { return nil }
        guard let escapeNodeIdentifier = dictionary[BTKeys.ESCAPE_NODE_KEY] as? String else { return nil }
        guard let targetRssi = dictionary[BTKeys.TARGET_RSSI_KEY] as? Int else { return nil }
        guard let escapeRssi = dictionary[BTKeys.ESCAPE_RSSI_KEY] as? Int else { return nil }
        guard let targetName = dictionary[BTKeys.TARGET_NAME_KEY] as? String else { return nil }
        
        self.targetNodeIdentifier = targetNodeIdentifier
        self.escapeNodeIdentifier = escapeNodeIdentifier
        self.targetRssi = targetRssi
        self.escapeRssi = escapeRssi
        self.targetName = targetName
    }
    
    // MARK: - Internal methods
    
    func asDictionary() -> [String: Any] {
        return [BTKeys.TARGET_NODE_KEY: self.targetNodeIdentifier,
                BTKeys.ESCAPE_NODE_KEY: self.escapeNodeIdentifier,
                BTKeys.TARGET_RSSI_KEY: self.targetRssi,
                BTKeys.ESCAPE_RSSI_KEY: self.escapeRssi,
                BTKeys.TARGET_NAME_KEY: self.targetName]
    }
}

// MARK: - Extensions

extension BTRouteItem: Equatable {
    public static func == (lhs: BTRouteItem, rhs: BTRouteItem) -> Bool {
        return  lhs.escapeNodeIdentifier == rhs.escapeNodeIdentifier &&
            lhs.targetNodeIdentifier == rhs.targetNodeIdentifier
    }
}
