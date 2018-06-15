//
//  BTBorder.swift
//  Wthere
//
//  Created by Marcos Borges on 22/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

// MARK: - Protocol

protocol BTBorderProtocol {
    var rx_message: Observable<Message> { get }
    var rx_routeInformation: Observable<[BTRouteItem]> { get }
    var nodeToAdd: Observable<BTNode> { get }
    var nodeToRemove: PublishSubject<BTNode> { get set }
    var nodeToUpdateRSSI: PublishSubject<(BTNode, NSNumber)> { get set }
//    var nodeToUpdateRouteItems: PublishSubject<(BTNode, [BTRouteItem])> { get set }
    
    func start()
    func sendMessageToAllUsers(message: Message)
    func sendMessageToUser(message: Message, user: User)
    func callForRssiUpdate()
}

// MARK: - Class

class BTBorder: BTBorderProtocol {
    
    // MARK: - Public properties
    
    var rx_message: Observable<Message> {
        return peripheralmanager.rx_message.asObservable()
    }
    
    var rx_routeInformation: Observable<[BTRouteItem]> {
        return peripheralmanager.rx_routeInformation.asObservable()
    }
    
    var nodeToAdd: Observable<BTNode> {
        return Observable.of(centralManager.nodeToAdd, peripheralmanager.nodeToAdd).merge()
//        return centralManager.nodeToAdd.asObservable()
    }
    
    var nodeToRemove = PublishSubject<BTNode>()
    var nodeToUpdateRSSI = PublishSubject<(BTNode, NSNumber)>()
    var nodeToUpdateRouteItems = PublishSubject<(BTNode, [BTRouteItem])>()
    
    // MARK: - Private properties
    
    private let peripheralmanager = BTPeripheralManager.shared
    private let centralManager = BTCentralManager.shared
    private var bag = DisposeBag()
    
    // MARK: - initialization
    
    init() {
        setupRx()
    }
    
    // MARK: - public methods
    
    func start() {
        cleanUp()
        
        guard let node = Storage.shared.currentUser?.node else { return }
        peripheralmanager.configure(node: node)
        
        peripheralmanager.startAdvertising()
        centralManager.startScanning()
    }
    
    func sendMessageToAllUsers(message: Message) {
        centralManager.sendMessageToAllUsers(message: message)
    }
    
    func sendMessageToUser(message: Message, user: User) {
        centralManager.sendMessageToAllUsers(message: message)
    }
    
    func visibleNodesListDidUpdate() {
        
    }
    
    func callForRssiUpdate() {
        centralManager.callForRssiUpdate()
    }
    
    // MARK: - Private methods
    
    private func cleanUp() {
        // TO BE IMPLEMENTED !!! <<<---------------------------------------------------------
    }
    
    private func setupRx() {
        centralManager.peripheralToRemove.asObservable().subscribe(onNext: { [weak self] peripheral in
            guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier) else { return }
            self?.nodeToRemove.onNext(node)
        }).disposed(by: bag)

        centralManager.peripheralToUpdateRSSI.asObservable().subscribe(onNext: { [weak self] (peripheral, RSSI) in
            guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier) else { return }
            self?.nodeToUpdateRSSI.onNext((node, RSSI))
        }).disposed(by: bag)
        
//        centralManager.peripheralToUpdateRouteItems.asObservable().subscribe(onNext: { [weak self] (peripheral, items) in
//            guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier) else { return }
//            self?.nodeToUpdateRouteItems.onNext((node, items))
//        }).disposed(by: bag)
        
        Storage.shared.currentUser?.node.visibleNodeItems.asObservable().skip(1).subscribe(onNext: { [weak self] items in
//            self?.peripheralmanager.visibleNodesListDidUpdate(items: items)
            self?.centralManager.sendVisibleNodesListToAllUsers(items: items)
        }).disposed(by: bag)
    }
}
