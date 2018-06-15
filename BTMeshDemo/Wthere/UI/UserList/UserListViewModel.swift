//
//  UserListViewModel.swift
//  Wthere
//
//  Created by Marcos Borges on 01/06/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Class

class UserListViewModel {
    
    // MARK: - Public properties
    
    var dataSource: BehaviorSubject<Set<User>> {
        return Storage.shared.users
    }
    
    var bag = DisposeBag()
    
    // MARK: - Private properties
    
    private let router = BTRouter(border: BTBorder(), storage: Storage.shared)
    
    // MARK: - Initialization
    
    init() {
        setupBLE()
        setupRx()
    }
    
    // MARK: - Private methods
    
    private func setupBLE() {
        router.start()
    }
    
    private func setupRx() {
        //
    }
    
    private func updateDataSource(user: User) {
        var users = (try? dataSource.value()) ?? []
        users.insert(user)
        dataSource.onNext(users)
    }
}

