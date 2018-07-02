//
//  BTPeripheralManager.swift
//  BTMesh
//
//  Created by Marcos Borges on 16/05/2018.
//  Copyright © 2018 XRay Soft. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift

// MARK: - Class

public class BTPeripheralManager: NSObject {
    
    // MARK: - Public properties
    
    public static let shared = BTPeripheralManager()
    static var config: BTPeripheralManagerConfig?
    
    // MARK: - Internal properties
    
    var rx_message = PublishSubject<BTMessage>()
    var rx_routeInformation = PublishSubject<[BTRouteItem]>()
    var nodeToAdd = PublishSubject<BTNode>()
    
    // MARK: - Private properties
    
    internal var manager: CBPeripheralManager!
    internal var currentState = BehaviorSubject<CBManagerState>(value: .unknown)
    internal var messageDataCache: Data?
    internal var routeDataCache: Data?
    internal var storage: BTStorageProtocol!
    
    private var bag = DisposeBag()
    private var node: BTNode?
    private var subscribedCentrals: Set<CBCentral> = []
    private var routeNotificationCharacteristic: CBMutableCharacteristic?
    private var routeUpdateCharacteristic: CBMutableCharacteristic?

    // MARK: - Initialization
    
    override private init() {
        super.init()
        
        guard let storage = BTPeripheralManager.config?.storage else {
            fatalError("You MUST call config before accessing BTCentralManager!")
        }
        
        self.storage = storage
        manager = CBPeripheralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    // MARK: - Internal methods
    
    func configure(node: BTNode) {
        self.node = node
    }
    
    func startAdvertising() {
        guard let _ = node else { return }
        
        currentState.asObservable().filter{ $0 == .poweredOn }.subscribe(onNext: { [weak self] status in
            guard let `self` = self else { return }

            let service = self.createService()
            self.manager.add(service)

            let advertisementData = self.createAdvertisementData()
            self.manager.startAdvertising(advertisementData)
            
            debugPrint("Bluetooth powered on, sending broadcast messages.")
            
        }).disposed(by: bag)
    }
    
    func stopAdvertising() {
        manager.stopAdvertising()
    }
    
    // MARK: - Private methods
    
    private func createService() -> CBMutableService {
        let btmeshService = CBMutableService(type: BTServiceProperties.BTMESH_SERVICE_UUID, primary: true)
        
        let rxMessageCharacteristic = createRXMessageCharacteristic()
        let rxRouteUpdateCharacteristic = createRXRouteUpdateCharacteristic()
        var characteristicList: [CBMutableCharacteristic] = [rxMessageCharacteristic,
                                                             rxRouteUpdateCharacteristic]
        
        if let `node` = node {
            let identificationCharacteristic = createIdentificationCharacteristic(for: node)
            characteristicList.append(identificationCharacteristic)
        }
        
        btmeshService.characteristics = characteristicList
        return btmeshService
    }
    
    private func createRXMessageCharacteristic() -> CBMutableCharacteristic {
        return CBMutableCharacteristic(type: BTServiceProperties.Characteristics.Message_RX.UUID,
                                       properties: BTServiceProperties.Characteristics.Message_RX.PROPERTIES,
                                       value: nil,
                                       permissions: BTServiceProperties.Characteristics.Message_RX.PERMISSIONS)
    }
    
    private func createIdentificationCharacteristic(for node: BTNode) -> CBMutableCharacteristic {
        let identificationdData = BTSerialization.serializeIdentification(node: node)
        return CBMutableCharacteristic(type: BTServiceProperties.Characteristics.Identification.UUID,
                                       properties: BTServiceProperties.Characteristics.Identification.PROPERTIES,
                                       value: identificationdData,
                                       permissions: BTServiceProperties.Characteristics.Identification.PERMISSIONS)
    }
    
    private func createRXRouteUpdateCharacteristic() -> CBMutableCharacteristic {
        return CBMutableCharacteristic(type: BTServiceProperties.Characteristics.Route_update_RX.UUID,
                                       properties: BTServiceProperties.Characteristics.Route_update_RX.PROPERTIES,
                                       value: nil,
                                       permissions: BTServiceProperties.Characteristics.Route_update_RX.PERMISSIONS)
    }
    
    private func createAdvertisementData() -> [String: Any] {
        return [CBAdvertisementDataServiceUUIDsKey:[BTServiceProperties.BTMESH_SERVICE_UUID],
                                        CBAdvertisementDataLocalNameKey: node?.name ?? BTIdentifier.getDeviceId()]
    }
}


