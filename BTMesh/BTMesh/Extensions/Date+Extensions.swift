//
//  Date+Extensions.swift
//  BTMesh
//
//  Created by Marcos Borges on 21/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation

// MARK: - Extensions

extension Date {
    
    // MARK: - Public methods
    
    public func asString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
