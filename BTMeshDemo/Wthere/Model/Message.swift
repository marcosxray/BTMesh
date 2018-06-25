//
//  Message.swift
//  Wthere
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation

// MARK: - Class

class Message {
    
    // MARK: - Public properties
    
    private(set) var text: String
    private(set) var date: Date
    private(set) var sender: User
    private(set) var receiver: User
    
    // MARK: - Initialization
    
    init(text: String, date: Date, sender: User, receiver: User) {
        self.text = text
        self.date = date
        self.sender = sender
        self.receiver = receiver
        
    }
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.text == rhs.text
            && lhs.date == rhs.date
    }
}
