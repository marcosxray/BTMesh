//
//  BTUser.swift
//  BTMesh
//
//  Created by Marcos Borges on 01/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import UIKit

// MARK: - Class

public class BTUser {
    
    // MARK: - Public properties
    
    private(set) var node: BTNode
    public var name: String {
        return node.name
    }
    
    // MARK: - Initialization
    
    public init(node: BTNode) {
        self.node = node
    }
}

// MARK: - Extensions

extension BTUser: Equatable {
    public static func == (lhs: BTUser, rhs: BTUser) -> Bool {
        return lhs.node == rhs.node
    }
}

extension BTUser: Hashable {
    public var hashValue: Int {
        guard let identifier = UUID(uuidString: node.identifier) else { return Int(arc4random()) }
        return identifier.hashValue
    }
}
