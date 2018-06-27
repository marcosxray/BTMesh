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
    
    func start()
    func sendMessage(message: BTMessage, escapeNode: BTNode)
    func callForRssiUpdate()
}

// MARK: - Class

public class BTBorder: BTBorderProtocol {
    
    // MARK: - Public properties
    
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
    
    private let peripheralmanager = BTPeripheralManager.shared
    private let centralManager = BTCentralManager.shared
    private var bag = DisposeBag()
    
    // MARK: - initialization
    
    public init() {
        setupRx()
    }
    
    // MARK: - public methods
    
    public func start() {
        cleanUp()
        
        guard let node = BTStorage.shared.currentUser?.node else { return }
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
        centralManager.peripheralToRemove.asObservable().subscribe(onNext: { [unowned self] peripheral in
            guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier) else { return }
            self.nodeToRemove.onNext(node)
        }).disposed(by: bag)

        centralManager.peripheralToUpdateRSSI.asObservable().subscribe(onNext: { [weak self] (peripheral, RSSI) in
            guard let node = BTIdentifier.nodeForPeripheralIdentifier(identifier: peripheral.identifier) else { return }
            self?.nodeToUpdateRSSI.onNext((node, RSSI))
        }).disposed(by: bag)
        
        BTStorage.shared.currentUser?.node.visibleNodeItems.asObservable().skip(1).subscribe(onNext: { [weak self] items in
            self?.centralManager.sendVisibleNodesListToAllUsers(items: items)
        }).disposed(by: bag)
    }
}
