//
//  TextFieldTableCell.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/16/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class TextFieldTableCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
