//
//  ChatViewModel.swift
//  Wthere
//
//  Created by Marcos Borges on 20/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Class

class ChatViewModel { 
    
    // MARK: - Public properties
    
    var dataSource = BehaviorSubject<[Message]>(value: [])
    var bag = DisposeBag()
    
    // MARK: - Private properties
    
    private let router = BTRouter(border: BTBorder(), storage: Storage.shared)
    
    // MARK: - Initialization
    
    init() {
        setupRx()
    }
    
    // MARK: - Public methods
    
    func sendMessageToAllUsers(text: String) {
        
        // fake
//        var txt = ""
//        for _ in 0...10 {
//            txt += "\(arc4random())"
//        }
        // fake
        
        let message = Message(text: text, sender: Storage.shared.currentUser!, date: Date())
        updateDataSource(message: message)
        router.sendMessageToAllUsers(message: message)
    }
    
    // MARK: - Private methods
    
    private func setupRx() {
        router.rx_message.distinctUntilChanged().subscribe(onNext: { [weak self] message in
            self?.updateDataSource(message: message)
        }).disposed(by: bag)
    }
    
    private func updateDataSource(message: Message) {
        var messages = (try? dataSource.value()) ?? []
        messages.append(message)
        dataSource.onNext(messages)
    }
}
