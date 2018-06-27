//
//  BTSerialization.swift
//  BTMesh
//
//  Created by Marcos Borges on 01/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation

// MARK: - Class

class BTSerialization {
    
    // MARK: - Message
    
    static func serializeMessage(sender: BTNode, receiver: BTNode, message: String) -> Data? {
        let senderDictionary = sender.asDictionary()
        let receiverDictionary = receiver.asDictionary()
        
        guard let messageData = message.data(using: .utf8) else { return nil }
        
        let dataDictionary: [String: Any] = [BTKeys.MESSAGE_SENDER_NODE_KEY: senderDictionary,
                                             BTKeys.MESSAGE_RECEIVER_NODE_KEY: receiverDictionary,
                                             BTKeys.MESSAGE_KEY: messageData]
        
        return Data(withDictionary: dataDictionary)
    }
    
    static func deserializeMessage(data: Data) -> (sender: BTNode, receiver: BTNode, message: String)? {
        guard let dictionary = data.asDictionary() else { return nil }
        guard let senderDictionary = dictionary[BTKeys.MESSAGE_SENDER_NODE_KEY] as? [String: Any] else { return nil }
        guard let sender = BTNode(dictionary: senderDictionary) else { return nil }
        
        guard let receiverDictionary = dictionary[BTKeys.MESSAGE_RECEIVER_NODE_KEY] as? [String: Any] else { return nil }
        guard let receiver = BTNode(dictionary: receiverDictionary) else { return nil }
        
        guard let messageData = dictionary[BTKeys.MESSAGE_KEY] as? Data else { return nil }
        guard let message = String(data: messageData, encoding: String.Encoding.utf8) as String? else { return nil }
        return (sender, receiver, message)
    }
    
    // MARK: - Identification
    
    static func serializeIdentification(node: BTNode) -> Data {
        let nodeDictionary = node.asDictionary()
        let dataDictionary: [String: Any] = [BTKeys.NODE_KEY: nodeDictionary]
        return Data(withDictionary: dataDictionary)
    }
    
    static func deserializeIdentification(data: Data) -> BTNode? {
        guard let dictionary = data.asDictionary() else { return nil }
        guard let nodeDictionary = dictionary[BTKeys.NODE_KEY] as? [String: Any] else { return nil }
        guard let node = BTNode(dictionary: nodeDictionary) else { return nil }
        return node
    }
    
    // MARK: - Route notification
    
    static func serializeRouteInformation(node: BTNode, items: [BTRouteItem]) -> Data? {
        var array: [[String: Any]] = []
        for item in items {
            let dictionary = item.asDictionary()
            array.append(dictionary)
        }
        let dataDictionary: [String: Any] = [BTKeys.NODE_KEY: node.asDictionary(),
                                             BTKeys.ROUTE_ITEMS_KEY: array]
        return Data(withDictionary: dataDictionary)
    }
    
    static func deserializeRouteInformation(data: Data) -> (node: BTNode, items: [BTRouteItem])? {
        guard let dictionary = data.asDictionary() else { return nil }
        guard let nodeDictionary = dictionary[BTKeys.NODE_KEY] as? [String: Any] else { return nil }
        guard let dataArray = dictionary[BTKeys.ROUTE_ITEMS_KEY] as? [[String: Any]] else { return nil }
        
        guard let node = BTNode(dictionary: nodeDictionary) else { return nil }
        
        var items: [BTRouteItem] = []
        for dictionary in dataArray {
            if let item = BTRouteItem(dictionary: dictionary) {
                items.append(item)
            }
        }
        return (node, items)
    }
}


