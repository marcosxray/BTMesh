//
//  Date+Extensions.swift
//  Wthere
//
//  Created by Marcos Borges on 21/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation

// MARK: - Extensions

extension Date {
    
    // MARK: - Public methods
    
    func asString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
