//
//  UserListViewController.swift
//  BTMeshDemo
//
//  Created by Marcos Borges on 01/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import UIKit
import RxSwift
import BTMesh

// MARK: - Class

class UserListViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties
    
    var viewModel = UserListViewModel()
    
    // MARK: - Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.title = "Users" // Storage.shared.currentUser?.name
        setupRx()
    }
    
    // MARK: - Actions
    
    @IBAction func goToAllUsers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "chatVC")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Private methods
    
    private func goToUser(user: User) {
        debugPrint("Go to user: \(user.name)")
    }
    
    private func setupRx() {
        viewModel.dataSource.asObservable().subscribe(onNext: { [weak self] dataSource in
            self?.tableView.reloadData()
        }).disposed(by: bag)
    }
}

// MARK: - TableView Datasource

extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let users = (try? viewModel.dataSource.value()) ?? []
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = UserListCell.cellIdentifier
        guard let users = try? viewModel.dataSource.value() else { return UITableViewCell() }
        
        let user = users[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserListCell else {
            return UITableViewCell()
        }

        cell.nameLabel.text = user.name
        return cell
    }
}

// MARK: - TableView Delegate

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let users = try? viewModel.dataSource.value() else { return }
        let usersArray: [User] = users.map{ $0 }
        let user = usersArray[indexPath.row]
        goToUser(user: user)
    }
}
