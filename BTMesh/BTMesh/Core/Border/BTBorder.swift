//
//  BTBorder.swift
//  BTMesh
//
//  Created by Marcos Borges on 22/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

// MARK: - Protocol

public protocol BTBorderProtocol {
    var rx_message: Observable<BTMessage> { get }
    var rx_routeInformation: Observable<[BTRouteItem]> { get }
    var nodeToAdd: Observable<BTNode> { get }
    var nodeToRemove: PublishSubject<BTNode> { get set }
    var nodeToUpdateRSSI: PublishSubject<(BTNode, NSNumber)> { get set }
    
    init(peripheralManager: BTPeripheralManager,
         centralManager: BTCentralManager,
         storage: BTStorageProtocol)
    
    func start()
    func sendMessage(message: BTMessage, escapeNode: BTNode)
    func callForRssiUpdate()
}

// MARK: - Class

public class BTBorder: BTBorderProtocol {
    
    // MARK: - Public properties

    public private(set) var peripheralmanager: BTPeripheralManager
    public private(set) var centralManager: BTCentralManager
    public private(set) var storage: BTStorageProtocol
    
    public var rx_message: Observable<BTMessage> {
        return peripheralmanager.rx_message.asObservable()
    }
    
    public var rx_routeInformation: Observable<[BTRouteItem]> {
        return peripheralmanager.rx_routeInformation.asObservable()
    }
    
    public var nodeToAdd: Observable<BTNode> {
        return Observable.of(centralManager.nodeToAdd, peripheralmanager.nodeToAdd).merge()
    }
    
    public var nodeToRemove = PublishSubject<BTNode>()
    public var nodeToUpdateRSSI = PublishSubject<(BTNode, NSNumber)>()
    
    // MARK: - Internal properties
    
    var nodeToUpdateRouteItems = PublishSubject<(BTNode, [BTRouteItem])>()
    
    // MARK: - Private properties
    
    private var bag = DisposeBag()
    
    // MARK: - initialization
    
    public required init(peripheralManager: BTPeripheralManager,
                         centralManager: BTCentralManager,
                         storage: BTStorageProtocol) {
        
        self.peripheralmanager = peripheralManager
        self.centralManager = centralManager
        self.storage = storage
        setupRx()
    }
    
    // MARK: - public methods
    
    public func start() {
        cleanUp()
        
        guard let node = storage.currentUser?.node else { return }
        peripheralmanager.configure(node: node)
        
        peripheralmanager.startAdvertising()
        centralManager.startScanning()
    }
    
    public func sendMessage(message: BTMessage, escapeNode: BTNode) {
        centralManager.sendMessage(message: message, escapeNode: escapeNode)
    }
    
    public func callForRssiUpdate() {
        centralManager.callForRssiUpdate()
    }
    
    // MARK: - Internal methods
    
    func visibleNodesListDidUpdate() {
        debugPrint("????????????")
    }
    
    // MARK: - Private methods
    
    private func cleanUp() {
        // TO BE IMPLEMENTED !!! <<<---------------------------------------------------------
    }
    
    private func setupRx() {
        centralManager.peripheralToRemove.asObservable().subscribe(onNext: { [weak self] peripheral in
            guard let weakSelf = self else { return }
            guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier, storage: weakSelf.storage) else { return }
            weakSelf.nodeToRemove.onNext(node)
        }).disposed(by: bag)

        centralManager.peripheralToUpdateRSSI.asObservable().subscribe(onNext: { [weak self] (peripheral, RSSI) in
            guard let weakSelf = self else { return }
            guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier, storage: weakSelf.storage) else { return }
            weakSelf.nodeToUpdateRSSI.onNext((node, RSSI))
        }).disposed(by: bag)
        
        storage.currentUser?.node.visibleNodeItems.asObservable().skip(1).subscribe(onNext: { [weak self] items in
            self?.centralManager.sendVisibleNodesListToAllUsers(items: items)
        }).disposed(by: bag)
    }
}
