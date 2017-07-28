//
//  LobbyItem.swift
//  thecue
//
//  Created by Benjamin Grima on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

struct LobbyItem {
    var createdAt: Date
    var player1: Player
    var player2: Player?
    init?(withDictionnary dictionnary: [String: AnyObject]) {
        guard let player1Data = dictionnary["player1"] as? [String: AnyObject],
            let player1 = Player(withDictionnary: player1Data),
            let createdAt = dictionnary["createdAt"] as? TimeInterval else {
                return nil
        }

        self.createdAt = Date(timeIntervalSince1970: createdAt / 1000)
        self.player1 = player1

        if let player2Data = dictionnary["player2"] as? [String: AnyObject] {
            self.player2 = Player(withDictionnary: player2Data)
        }
    }
}
