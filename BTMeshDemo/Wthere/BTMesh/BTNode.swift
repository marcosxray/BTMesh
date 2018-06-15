//
//  User.swift
//  Wthere
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import UIKit
import CoreBluetooth
import RxSwift

// MARK: - Class

class BTNode {
    
    // MARK: - Public properties
    
    private(set) var name: String
    private(set) var identifier: String
    private(set) var visibleNodeItems = BehaviorSubject<[BTRouteItem]>(value: [])
    
    var peripheralId: UUID? {
        get {
            return self.peripheral?.identifier
        }
    }
    
    var centralId: UUID? {
        get {
            return self.central?.identifier
        }
    }
    
    var RSSI: Int = 0
    var visibleNodesDidChange = PublishSubject<Void>()
    
    
    // MARK: - Private properties
    
    private var peripheral: CBPeripheral?
    private var central: CBCentral?
    
    // MARK: - Initialization
    
    init(name: String, identifier: String) {
        self.name = name
        self.identifier = identifier
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[BTKeys.NODE_NAME] as? String else { return nil }
        guard let identifier = dictionary[BTKeys.NODE_IDENTIFIER] as? String else { return nil }
        
        self.name = name
        self.identifier = identifier
    }
    
    // MARK: - Public methods

    func asDictionary() -> [String: Any] {
        return [BTKeys.NODE_NAME: self.name,
                BTKeys.NODE_IDENTIFIER: self.identifier]
    }
    
    func updatePeripheral(peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
    
//    func callForRssiUpdate() {
//        peripheral?.readRSSI()
//    }
}

// MARK: - Extension: node items

extension BTNode {
    
    func addVisibleNodeItem(item: BTRouteItem) {
        guard var items = try? visibleNodeItems.value() else { return }
        if let _ = items.index(of: item) {
            _ = updateVisibleNodeItem(item: item)
            return
        }
        items.append(item)
        visibleNodeItems.onNext(items)
    }
    
    func removeVisibleNodeItem(item: BTRouteItem) -> Bool {
        guard var items = try? visibleNodeItems.value() else { return false }
        guard let index = items.index(of: item) else { return false }
        items.remove(at: index)
        visibleNodeItems.onNext(items)
        return true
    }
    
    func updateVisibleNodeItem(item: BTRouteItem) -> Bool {
        guard removeVisibleNodeItem(item: item) else { return false }
        addVisibleNodeItem(item: item)
        return true
    }
}

// MARK: - Extensions

extension BTNode: Equatable {
    static func == (lhs: BTNode, rhs: BTNode) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
