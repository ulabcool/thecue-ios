//
//  UsersListViewController.swift
//  thecue
//
//  Created by Adil Bougamza on 28/07/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit


protocol UsersListViewControllerDelegate {
    func didSelectUser(name : String)
}

class  UsersListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: UsersListViewControllerDelegate?
    
    let myArray: [String] = ["First","Second","Third"]
    
    override func viewDidLoad() {
        // load users
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
    }
}
extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
        delegate?.didSelectUser(name: myArray[indexPath.row])
    }
}
extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        return cell
    }
}
