//
//  ChatCell.swift
//  Wthere
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
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
    
    // MARK: - Overriden methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
