//
//  Message.swift
//  BTMesh
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation

// MARK: - Class

public class Message {
    
    // MARK: - Public properties
    
    public private(set) var text: String
    public private(set) var date: Date
    public private(set) var sender: User
    public private(set) var receiver: User
    
    // MARK: - Initialization
    
    public init(text: String, date: Date, sender: User, receiver: User) {
        self.text = text
        self.date = date
        self.sender = sender
        self.receiver = receiver
        
    }
}

extension Message: Equatable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.text == rhs.text
            && lhs.date == rhs.date
    }
}
