//
//  LobbyItemTableViewCell.swift
//  thecue
//
//  Created by Benjamin Grima on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

class LobbyItemTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
