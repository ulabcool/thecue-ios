//
//  LobbyViewController.swift
//  thecue
//
//  Created by Benjamin Grima on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {

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

        viewModel.onItemsChanged = {[unowned self] in
            self.tableView.isHidden = self.viewModel.items.count == 0
            self.tableView.reloadData()
            self.viewModel.onLoadingChanged?()
        }

        viewModel.onLoadingChanged = {[unowned self] in
            self.button.layer.borderWidth = 0.0
            self.button.layer.cornerRadius = 0
            self.button.setTitleColor(UIColor.white, for: .normal)
            
            if self.viewModel.isInTheQueue {
                self.button.backgroundColor = UIColor.leaveQueueColor
                self.button.setTitle("Leave queue", for: .normal)
            }
            else if self.viewModel.isPlaying {
                self.button.layer.borderColor = UIColor.joinQueueColor.cgColor
                self.button.backgroundColor = UIColor.backgroundColor
                self.button.setTitle("Done playing", for: .normal)
                self.button.setTitleColor(UIColor.joinQueueColor, for: .normal)
                self.button.layer.borderWidth = 1
                self.button.layer.cornerRadius = 4
            }
            else {
                self.button.backgroundColor = UIColor.joinQueueColor
                self.button.setTitle("Join queue", for: .normal)
            }
            self.button.isEnabled = !self.viewModel.isLoading
        }
    }

    func changedSegment(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        viewModel.didSelectTable(atIndex: index)
    }

    @IBAction func buttonAction(_ sender: Any) {
        viewModel.didTapButton()
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
                cell.nameLabel.text = item.name
                return cell
            }
            let cell = UITableViewCell()
            cell.textLabel?.text = "The table is free"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "lobbyItemTableViewCellIdentifier", for: indexPath) as! LobbyItemTableViewCell
        let item = viewModel.waitingGames[indexPath.row]
        cell.nameLabel.text = item.name
        return cell
    }
}
