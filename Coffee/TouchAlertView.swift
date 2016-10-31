//
//  TouchAlertView.swift
//  Banking
//
//  Created by Niranjan Ravichandran on 10/3/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

protocol ButtonResponderDelegate {
    func buttonPressed(sender: UIButton)
}

class TouchAlertView: UIView, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var exampleNumber: Int? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var icons: [String] = ["Correct.png", "Correct.png", "Warning.png"]
    var images: [String] = ["Fingers.png", "Password-Filled.png", "Artboard.png"]
    var buttonResponderDelegate: ButtonResponderDelegate?
    
    func configure() {
        self.backgroundColor = UIColor.white
        tableView = UITableView(frame: self.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableCell")
        tableView.register(UINib(nibName: "ButtonsTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableCell")
        tableView.register(UINib(nibName: "ListTwoTableCell", bundle: nil), forCellReuseIdentifier: "ListTwoTableCell")
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        self.addSubview(tableView)
        
        //self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 3 {
            if exampleNumber == 2 || exampleNumber == 4 {
                //Cell implementation for type 2 & 4
                let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as! ListTableViewCell
                cell.iconImageView.image = UIImage(named: icons[indexPath.row])
                cell.cellLabel.text = Utility.listOne[indexPath.row]
                return cell
            }else {
                //Cell implementation for type 3 & 5
                let cell = tableView.dequeueReusableCell(withIdentifier: "ListTwoTableCell", for: indexPath) as! ListTwoTableCell
                cell.icon.image = UIImage(named: self.icons[indexPath.row])
                cell.cellImageView.image = UIImage(named: self.images[indexPath.row])
                cell.cellLabel.text = Utility.listTwo[indexPath.row]
                return cell
            }
        }else {
            //Cell implementation for buttons
            let cell = UITableViewCell()
            return cell
        }
    }
    
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 40))
        headerView.backgroundColor = Utility.navBarColor
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        titleLabel.text = "Alert"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.center = headerView.center
        headerView.addSubview(titleLabel)
        return headerView
    } */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 45
        }else {
            if exampleNumber == 2 || exampleNumber == 4 {
                 let computedHeight = Utility.calculateHeightForString(inString: Utility.listOne[indexPath.row]) + 15
                return computedHeight > 65 ? computedHeight : 60
            }else {
                return 125
            }
        }
    }

}
