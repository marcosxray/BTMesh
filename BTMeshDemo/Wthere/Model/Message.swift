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
    private(set) var sender: User
    private(set) var date: Date
    
    // MARK: - Initialization
    
    init(text: String, sender: User, date: Date) {
        self.text = text
        self.sender = sender
        self.date = date
    }
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.text == rhs.text && lhs.text == rhs.text
    }
}
