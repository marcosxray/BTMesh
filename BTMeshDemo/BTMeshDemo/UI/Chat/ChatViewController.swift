//
//  ChatViewController.swift
//  BTMeshDemo
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import UIKit
import RxSwift
import BTMesh

// MARK: - Class

class ChatViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties
    
    var viewModel = ChatViewModel()
    
    // MARK: - Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
        setupRx()
    }
    
    // MARK: - Actions
    
    @IBAction func sendDidTouch() {
        if let txt = textField.text, txt != "" {
            viewModel.sendMessageToAllUsers(text: txt)
            textField.text = nil
            textField.resignFirstResponder()
        }
    }
    
    // MARK: - Private methods
    
    private func setupVisuals() {
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.title = BTStorage.shared.currentUser?.name
    }
    
    private func setupRx() {
        viewModel.dataSource.asObservable().subscribe(onNext: { [weak self] dataSource in
            self?.tableView.reloadData()
        }).disposed(by: bag)
    }
}

// MARK: - TableView Datasource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let messages = (try? viewModel.dataSource.value()) ?? []
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIdentifier = ChatCell.cellIdentifier
        guard let messages = try? viewModel.dataSource.value() else { return UITableViewCell() }
        let message = messages[indexPath.row]
        
        if message.sender == BTStorage.shared.currentUser {
            cellIdentifier = "chatMineCell"
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatCell else {
            return UITableViewCell()
        }
        
        cell.messageLabel.text = message.text
        cell.nameLabel.text = message.sender.name
        cell.dateLabel.text = "\(message.date.asString())"
        
        return cell
    }
}


