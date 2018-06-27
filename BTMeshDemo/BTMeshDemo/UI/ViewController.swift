//
//  ViewController.swift
//  BTMeshDemo
//
//  Created by Marcos Borges on 27/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import UIKit
import CoreBluetooth
import BTMesh

// MARK: - Class

class ViewController: UIViewController {
    
    @IBOutlet weak var nateTextField: UITextField!
    // MARK: - Overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func startDidTouch() {
        let storage = BTStorage.shared
        var name = "Unknown name"
        
        if let userName = nateTextField.text, userName != "" {
            name = userName
        }
        
        let node = BTNode(name: name,
                          identifier: BTIdentifier.getDeviceId())
        
        storage.currentUser = BTUser(node: node)
        loadNextScreen()
    }
    
    // MARK: - Private methods
    
    private func loadNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "userListVC")
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

