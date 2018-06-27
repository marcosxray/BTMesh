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
    
    var dataSource: BehaviorSubject<Array<BTUser>> {
        return BTStorage.shared.users
    }
    
    var bag = DisposeBag()
    
    // MARK: - Private properties
    
    private var router: BTRouter?
    
    // MARK: - Initialization
    
    init() {
        BTRouter.config = BTRouterConfig(service_ID: "06CD7CAA-CA1C-4C9A-9EC1-E60EDE7B3C2E",
                                         identification_ID: "4A4C566D-AAD3-47C8-A2C8-E8CD2BDDBCAF",
                                         route_update_RX_ID: "7773C2AB-F128-40E2-BCE4-9D4F02101030",
                                         message_RX_ID: "3B7C432B-5D97-4C82-BF45-B6B8C097EF9C")
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
    
    private func updateDataSource(user: BTUser) {
        var users = (try? dataSource.value()) ?? []
        users.append(user)
        dataSource.onNext(users)
    }
}

