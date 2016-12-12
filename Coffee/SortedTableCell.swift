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
        if appdelegate.isDisplayAll {
            appdelegate.selectedUsers = userList
        }
        if appdelegate.studyNumber == 3 {
            for i in 0..<sortedImageViews.count {
                sortedImageViews[i].clipsToBounds = true
                if appdelegate.selectedUsers[i] != "None" {
                    sortedImageViews[i].image = UIImage(named: appdelegate.selectedUsers[i])
                    titles[i].text = appdelegate.selectedUsers[i]
                }
            }
        }else {
            var i = 0, j = 4
            while (i < sortedImageViews.count && j >= 0) {
                //print("###", i, j)
                while (appdelegate.selectedUsers[j] == "None") {
                    //print("@@@",appdelegate.selectedUsers[j])
                    if j == 0 || appdelegate.selectedUsers[j] != "None"{
                        break
                    }
                    j -= 1
                }
                //print(">>>", appdelegate.selectedUsers[j])
                sortedImageViews[i].clipsToBounds = true
                sortedImageViews[i].image = UIImage(named: appdelegate.selectedUsers[j])
                titles[i].text = appdelegate.selectedUsers[j]
                i += 1
                j -= 1
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
