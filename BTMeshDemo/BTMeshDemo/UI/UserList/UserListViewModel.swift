//
//  UserListViewModel.swift
//  BTMeshDemo
//
//  Created by Marcos Borges on 01/06/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import RxSwift
import BTMesh

// MARK: - Class

class UserListViewModel {
    
    // MARK: - Public properties
    
    var dataSource: BehaviorSubject<Array<User>> {
        return Storage.shared.users
    }
    
    var bag = DisposeBag()
    
    // MARK: - Private properties
    
    private var router: BTRouter?
    
    // MARK: - Initialization
    
    init() {
        BTRouter.config = BTRouterConfig(border: BTBorder(), storage: Storage.shared)
        router = BTRouter.shared
        setupBLE()
        setupRx()
    }
    
    // MARK: - Private methods
    
    private func setupBLE() {
        router?.start()
    }
    
    private func setupRx() {
        //
    }
    
    private func updateDataSource(user: User) {
        var users = (try? dataSource.value()) ?? []
        users.append(user)
        dataSource.onNext(users)
    }
}

