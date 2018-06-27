//
//  BTMessage.swift
//  BTMesh
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation

// MARK: - Class

public class BTMessage {
    
    // MARK: - Public properties
    
    public private(set) var text: String
    public private(set) var date: Date
    public private(set) var sender: BTUser
    public private(set) var receiver: BTUser
    
    // MARK: - Initialization
    
    public init(text: String, date: Date, sender: BTUser, receiver: BTUser) {
        self.text = text
        self.date = date
        self.sender = sender
        self.receiver = receiver
        
    }
}

extension BTMessage: Equatable {
    public static func == (lhs: BTMessage, rhs: BTMessage) -> Bool {
        return lhs.text == rhs.text
            && lhs.date == rhs.date
    }
}
