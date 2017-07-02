//
//  LobbyItem.swift
//  thecue
//
//  Created by Benjamin Grima on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

struct LobbyItem {
    var name: String
    var userId: String
    var createdAt: Date
    init?(withDictionnary dictionnary: [String: AnyObject]) {
        guard let name = dictionnary["name"] as? String,
            let userId = dictionnary["userId"] as? String,
            let createdAt = dictionnary["createdAt"] as? TimeInterval else {
                return nil
        }

        self.createdAt = Date(timeIntervalSince1970: createdAt / 1000)
        self.name = name
        self.userId = userId
    }
}
