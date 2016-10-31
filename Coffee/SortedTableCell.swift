//
//  SortedTableCell.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/20/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class SortedTableCell: UITableViewCell {

    @IBOutlet var sortedImageViews: [UIImageView]!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet var titles: [UILabel]!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var userList = ["Parent", "Sibling", "Co-worker", "Spouse", "Friend"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func configure() {
//        if appdelegate.studyNumber == 3 {
//            for i in 0..<userList.count {
//                sortedImageViews[i].clipsToBounds = true
//                sortedImageViews[i].image = UIImage(named: userList[i])
//                titles[i].text = userList[i]
//            }
//        }else {
            for i in 0..<sortedImageViews.count {
                sortedImageViews[i].clipsToBounds = true
                sortedImageViews[i].image = UIImage(named: appdelegate.selectedUsers[i])
                if appdelegate.selectedUsers[i] != "None" {
                    titles[i].text = appdelegate.selectedUsers[i]
                }
            }
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
