//
//  UserFactory.swift
//  BTMeshTests
//
//  Created by Marcos on 01/07/2018.
//  Copyright © 2018 Marcos Borges. All rights reserved.
//

import Foundation
@testable import BTMesh

struct UserFactory {
    
    static func generateUserA() -> BTUser {
        let node = NodeFactory.generateNode_A()
        let user = BTUser(node: node)
        return user
    }
    
    static func generateUserB() -> BTUser {
        let node = NodeFactory.generateNode_B()
        let user = BTUser(node: node)
        return user
    }
    
    static func generateUserC() -> BTUser {
        let node = NodeFactory.generateNode_C()
        let user = BTUser(node: node)
        return user
    }
    
    static func generateUserD() -> BTUser {
        let node = NodeFactory.generateNode_D()
        let user = BTUser(node: node)
        return user
    }
    
    static func generateUserE() -> BTUser {
        let node = NodeFactory.generateNode_E()
        let user = BTUser(node: node)
        return user
    }
    
    static func generateUserF() -> BTUser {
        let node = NodeFactory.generateNode_F()
        let user = BTUser(node: node)
        return user
    }
    
    static func generateUserG() -> BTUser {
        let node = NodeFactory.generateNode_G()
        let user = BTUser(node: node)
        return user
    }
    
    static func generateUserH() -> BTUser {
        let node = NodeFactory.generateNode_H()
        let user = BTUser(node: node)
        return user
    }
    
    static func generateUserI() -> BTUser {
        let node = NodeFactory.generateNode_I()
        let user = BTUser(node: node)
        return user
    }
}
