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
    
    func start()
    func sendMessage(message: Message, escapeNode: BTNode)
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
    
    func sendMessage(message: Message, escapeNode: BTNode) {
        centralManager.sendMessage(message: message, escapeNode: escapeNode)
    }
    
    func visibleNodesListDidUpdate() {
        debugPrint("????????????")
    }
    
    func callForRssiUpdate() {
        centralManager.callForRssiUpdate()
    }
    
    // MARK: - Private methods
    
    private func cleanUp() {
        // TO BE IMPLEMENTED !!! <<<---------------------------------------------------------
    }
    
    private func setupRx() {
        centralManager.peripheralToRemove.asObservable().subscribe(onNext: { [unowned self] peripheral in
            guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier) else { return }
            self.nodeToRemove.onNext(node)
        }).disposed(by: bag)

        centralManager.peripheralToUpdateRSSI.asObservable().subscribe(onNext: { [weak self] (peripheral, RSSI) in
            guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier) else { return }
            self?.nodeToUpdateRSSI.onNext((node, RSSI))
        }).disposed(by: bag)
        
        Storage.shared.currentUser?.node.visibleNodeItems.asObservable().skip(1).subscribe(onNext: { [weak self] items in
            self?.centralManager.sendVisibleNodesListToAllUsers(items: items)
        }).disposed(by: bag)
    }
}
