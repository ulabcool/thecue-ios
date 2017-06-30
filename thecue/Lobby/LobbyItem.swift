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

    init?(withDictionnary dictionnary: [String: AnyObject]) {
        guard let name = dictionnary["name"] as? String,
            let userId = dictionnary["userId"] as? String else {
                return nil
        }
        self.name = name
        self.userId = userId
    }
}
