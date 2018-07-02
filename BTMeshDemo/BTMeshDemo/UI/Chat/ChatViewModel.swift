//
//  ChatViewModel.swift
//  BTMeshDemo
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import RxSwift
import BTMesh

// MARK: - Class

class ChatViewModel { 
    
    // MARK: - Public properties
    
    var dataSource = BehaviorSubject<[BTMessage]>(value: [])
    var bag = DisposeBag()
    
    // MARK: - Private properties
    
    private var router: BTRouter?
    
    // MARK: - Initialization
    
    init() {
        router = BTRouter.shared
        setupRx()
    }
    
    // MARK: - Public methods
    
    func sendMessageToAllUsers(text: String) {
        guard let users = try? BTStorage.shared.users.value() else { return }
        for user in users {
            sendMessageToUser(receiver: user, text: text, updatedataSoure: false)
        }
        
        // save a copy locally
        let message = BTMessage(text: text,
                              date: Date(),
                              sender: BTStorage.shared.currentUser!,
                              receiver: BTStorage.shared.currentUser!)
        updateDataSource(message: message)
    }
    
    func sendMessageToUser(receiver: BTUser, text: String, updatedataSoure: Bool = true) {
        let message = BTMessage(text: text,
                              date: Date(),
                              sender: BTStorage.shared.currentUser!,
                              receiver: receiver)
        
        router?.sendMessage(message: message)
        
        if updatedataSoure {
            updateDataSource(message: message)
        }
    }
    
    // MARK: - Private methods
    
    private func setupRx() {
        router?.rx_message.subscribe(onNext: { [weak self] message in
            self?.updateDataSource(message: message)
        }).disposed(by: bag)
    }
    
    private func updateDataSource(message: BTMessage) {
        var messages = (try? dataSource.value()) ?? []
        messages.append(message)
        dataSource.onNext(messages)
    }
}
