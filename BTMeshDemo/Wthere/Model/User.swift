//
//  User.swift
//  Wthere
//
//  Created by Marcos Borges on 01/06/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import UIKit

// MARK: - Class

class User {
    
    // MARK: - Public properties
    
    private(set) var node: BTNode
    var name: String {
        return node.name
    }
    
    // MARK: - Initialization
    
    init(node: BTNode) {
        self.node = node
    }
}

// MARK: - Extensions

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.node == rhs.node
    }
}

extension User: Hashable {
    var hashValue: Int {
        guard let identifier = UUID(uuidString: node.identifier) else { return Int(arc4random()) }
        return identifier.hashValue
    }
}
