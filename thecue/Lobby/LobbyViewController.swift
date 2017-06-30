//
//  LobbyViewController.swift
//  thecue
//
//  Created by Benjamin Grima on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit
import Firebase

class LobbyViewController: UIViewController {

    var refCurrentQueue: DatabaseReference?
    var tables: [Table] = []
    var items: [LobbyItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenForQueue(withKey: tables.first?.queue ?? "rokin")
    }

    func listenForQueue(withKey key: String) {
        refCurrentQueue = Database.database().reference(withPath: "queues/\(key)");
        refCurrentQueue?.observe(DataEventType.value, with: { (snapshot) in
            guard let queue = snapshot.value as? [[String: AnyObject]] else {
                return
            }
            let newItems = queue.flatMap{
                LobbyItem(withDictionnary: $0)
            }
            print(newItems)
            self.items = newItems
        })
    }
}
