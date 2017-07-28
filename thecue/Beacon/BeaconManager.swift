//
//  BeaconManager.swift
//  thecue
//
//  Created by Giacomo Pinato on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

class BeaconManager: ProximityContentManagerDelegate {

    static let shared = BeaconManager()
    var delegate: BeaconManagerDelegate? = nil
    let proximityContentManager: ProximityContentManager
    var isBeaconInRange: Bool = false
    
    init() {
        proximityContentManager = ProximityContentManager(
            beaconIDs: [
                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 55959, minor: 45134)
            ],
            beaconContentFactory: CachingContentFactory(beaconContentFactory: BeaconDetailsCloudFactory()))

        proximityContentManager.startContentUpdates()
        proximityContentManager.delegate = self
    }

    func proximityContentManager(_ proximityContentManager: ProximityContentManager, didUpdateContent content: AnyObject?) {

        if let _ = content as? BeaconDetails {
            print("in range")
            isBeaconInRange = true
            delegate?.beaconProximityChanged(inRange: true)
        } else {
            print("out of range")
            isBeaconInRange = false
            delegate?.beaconProximityChanged(inRange: false)
        }
    }

}

protocol BeaconManagerDelegate {
    func beaconProximityChanged(inRange: Bool)
}
