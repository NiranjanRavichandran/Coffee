//
//  ListTwoTableCell.swift
//  Banking
//
//  Created by Niranjan Ravichandran on 10/3/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class ListTwoTableCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
