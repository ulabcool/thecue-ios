//
//  Player.swift
//  thecue
//
//  Created by Benjamin Grima on 28/07/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation


struct Player {
    var name: String
    var userId: String
    var imageURL: String?
    init?(withDictionnary dictionnary: [String: AnyObject]) {
        guard let name = dictionnary["name"] as? String,
            let userId = dictionnary["userId"] as? String else {
                return nil
        }
        self.name = name
        self.userId = userId
        self.imageURL = dictionnary["imageUrl"] as? String
    }
}
