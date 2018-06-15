//
//  Data+Extensions.swift
//  Wthere
//
//  Created by Marcos Borges on 01/06/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation

// MARK: - Extensions

extension Data {
    
    // MARK: - Initialization
    
    init(withDictionary: [String: Any]) {
        self = NSKeyedArchiver.archivedData(withRootObject: withDictionary)
    }
    
    // MARK: - Public methods
    
    func asDictionary() -> [String: Any]? {
        guard let dictionary = NSKeyedUnarchiver.unarchiveObject(with: self) as? [String : Any] else { return nil }
        return dictionary
    }
}
