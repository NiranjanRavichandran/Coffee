//
//  ShowUserTableCell.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/19/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class ShowUserTableCell: UITableViewCell {
    
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
