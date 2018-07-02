//
//  ChatCell.swift
//  BTMeshDemo
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import UIKit

// MARK: - Class

class ChatCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Public properties
    
    static let cellIdentifier = "chatCell"
}
