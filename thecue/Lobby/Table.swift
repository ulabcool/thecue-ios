//
//  Table.swift
//  thecue
//
//  Created by Benjamin Grima on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

struct Table {
    var name: String
    var queue: String
    
    init?(withDictionnary dictionnary: [String: AnyObject]) {
        guard let name = dictionnary["name"] as? String,
            let queue = dictionnary["queue"] as? String else {
                return nil
        }
        self.name = name
        self.queue = queue
    }
    
}
