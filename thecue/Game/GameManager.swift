//
//  GameManaer.swift
//  thecue
//
//  Created by Giacomo Pinato on 28/07/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

protocol GameManagerDelegateProtocol {
    func gameHasStarted()
    func gameHasFinished()
}

class GameManager: BeaconManagerDelegate {

    static var shared = GameManager()
    var isGameOn: Bool = false
    var currentTimer: Timer? {
        willSet {
            currentTimer?.invalidate()
        }
    }
    var delegate: GameManagerDelegateProtocol?

    func startGameSession() {
        BeaconManager.shared.delegate = self
        checkForBeacon(forTime: 120)
        if BeaconManager.shared.isBeaconInRange {
            manualGameStart()
            delegate?.gameHasStarted()
        }
    }

    func manualGameStart() {
        currentTimer?.invalidate()
        isGameOn = true
    }

    func manualGameEnd() {
        isGameOn = false
        endGameSession()
    }

    private func endGameSession() {
        BeaconManager.shared.delegate = nil
    }
    
    private func checkForBeacon(forTime: Double) {
        currentTimer = Timer.scheduledTimer(withTimeInterval: forTime, repeats: false, block: { (_) in
            self.isGameOn = false
            self.delegate?.gameHasFinished()
            self.endGameSession()
        })
    }

    func beaconProximityChanged(inRange: Bool) {
        print(inRange)
        if inRange {
            currentTimer?.invalidate()
            if !isGameOn {
                isGameOn = true
                delegate?.gameHasStarted()
            }
            return
        }

        if !inRange && isGameOn {
            checkForBeacon(forTime: 60)
        }
    }
}
