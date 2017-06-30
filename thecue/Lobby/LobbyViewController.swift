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
            self.tableView.reloadData()
            self.viewModel.onLoadingChanged?()
        }

        viewModel.onLoadingChanged = {[unowned self] in
            if self.viewModel.isInTheQueue {
                self.button.backgroundColor = UIColor.leaveQueueColor
                self.button.setTitle("Leave queue", for: .normal)
            } else {
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

extension LobbyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lobbyItemTableViewCellIdentifier", for: indexPath) as! LobbyItemTableViewCell
        let item = viewModel.items[indexPath.row]
        cell.nameLabel.text = item.name
        return cell
    }
}
