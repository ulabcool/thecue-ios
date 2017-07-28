//
//  LobbyViewController.swift
//  thecue
//
//  Created by Benjamin Grima on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController, UsersListViewControllerDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: LobbyViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.removeAllSegments()
        for (index, table) in viewModel.tables.enumerated() {
            segmentedControl.insertSegment(withTitle: table.name, at: index, animated: false)
        }

        segmentedControl.addTarget(self, action: #selector(LobbyViewController.changedSegment(sender:)), for: [.valueChanged])
        segmentedControl.selectedSegmentIndex = 0
        changedSegment(sender: segmentedControl)

        viewModel.onItemsChanged = { [unowned self] in
            self.tableView.isHidden = self.viewModel.items.count == 0
            self.tableView.reloadData()
            self.viewModel.onLoadingChanged?()
        }

        viewModel.onLoadingChanged = { [unowned self] in
            self.button.layer.borderWidth = 0.0
            self.button.layer.cornerRadius = 0
            self.button.setTitleColor(UIColor.white, for: .normal)

            switch self.viewModel.playerStatus {
            case .inQueue:
                self.button.backgroundColor = UIColor.leaveQueueColor
                self.button.setTitle("Leave queue", for: .normal)
            case .playingGame:
                self.button.layer.borderColor = UIColor.joinQueueColor.cgColor
                self.button.backgroundColor = UIColor.backgroundColor
                self.button.setTitle("Done playing", for: .normal)
                self.button.setTitleColor(UIColor.joinQueueColor, for: .normal)
                self.button.layer.borderWidth = 1
                self.button.layer.cornerRadius = 4
            case .idle:
                self.button.backgroundColor = UIColor.joinQueueColor
                self.button.setTitle("Join queue", for: .normal)
            case .startingGame:
                self.button.backgroundColor = UIColor.joinQueueColor
                self.button.setTitle("Start game!", for: .normal)
            }
            self.button.isEnabled = !self.viewModel.isLoading
        }
        
        performSegue(withIdentifier: "showListViewController", sender: self)
    }
    
    func didSelectUser(name: String) {
        print("user is : \(name)")
    }

    func changedSegment(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        viewModel.didSelectTable(atIndex: index)
    }

    @IBAction func buttonAction(_ sender: Any) {
        viewModel.didTapButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destController = segue.destination as? UsersListViewController {
            destController.delegate = self
        }
    }
    
}
extension LobbyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "Queue"
    }
}
extension LobbyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.waitingGames.count > 0 ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.isTableFree ? 0 : 1
        }
        return viewModel.waitingGames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if !viewModel.isTableFree {
                let cell = tableView.dequeueReusableCell(withIdentifier: "lobbyItemTableViewCellIdentifier", for: indexPath) as! LobbyItemTableViewCell
                let item = viewModel.items[indexPath.row]
                cell.player1 = item.player1
                return cell
            }
            let cell = UITableViewCell()
            cell.textLabel?.text = "The table is free"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "lobbyItemTableViewCellIdentifier", for: indexPath) as! LobbyItemTableViewCell
        let item = viewModel.waitingGames[indexPath.row]
        cell.player1 = item.player1
        return cell
    }
}
