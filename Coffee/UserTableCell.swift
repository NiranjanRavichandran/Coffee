//
//  UserTableCell.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/19/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class UserTableCell: UITableViewCell {
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
