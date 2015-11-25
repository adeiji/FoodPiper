//
//  MessageTableViewCell.swift
//  FoodPiper
//
//  Created by adeiji on 11/20/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    var action:Action!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
