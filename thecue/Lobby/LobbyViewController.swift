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

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var refCurrentQueue: DatabaseReference?
    var tables: [Table] = []
    var items: [LobbyItem] = []
    let redColor = UIColor(red: 244/255, green: 96/255, blue: 110/255, alpha: 1.0)
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.removeAllSegments()
        for (index, table) in tables.enumerated() {
            segmentedControl.insertSegment(withTitle: table.name, at: index, animated: false)
        }
        
        segmentedControl.addTarget(self, action: #selector(LobbyViewController.changedSegment(sender:)), for: [.valueChanged])
        segmentedControl.selectedSegmentIndex = 0
        
    }
    
    func changedSegment(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let table = tables[index]
        listenForQueue(withKey: table.queue)
    }

    func listenForQueue(withKey key: String) {
        self.items = []
        self.tableView.reloadData()
        refCurrentQueue = Database.database().reference(withPath: "queues/\(key)");
        refCurrentQueue?.observe(DataEventType.value, with: { (snapshot) in
            guard let queue = snapshot.value as? [String: AnyObject] else {
                return
            }
            let array = Array(queue.values)
            guard let allValues = array as? [[String:AnyObject]] else {
                return
            }
            
            var newItems = allValues.flatMap{
                LobbyItem(withDictionnary: $0)
            }
            
            newItems.sort { $0.createdAt < $1.createdAt }
            self.items = newItems
            self.tableView.reloadData()
        })
    }
    @IBAction func buttonAction(_ sender: Any) {
        let item = ["userId": Auth.auth().currentUser!.providerData[0].uid,
                    "name": Auth.auth().currentUser!.displayName,
                    "createdAt": ServerValue.timestamp()] as [String : Any]
        refCurrentQueue?.child(Auth.auth().currentUser!.providerData[0].uid).setValue(item)
    }
}

extension LobbyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lobbyItemTableViewCellIdentifier", for: indexPath) as! LobbyItemTableViewCell
        let item = items[indexPath.row]
        cell.nameLabel.text = item.name
        
        return cell
    }
}
