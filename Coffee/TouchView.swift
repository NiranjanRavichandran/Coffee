//
//  TouchView.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/17/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class TouchView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var buttonDelegate: ButtonResponderDelegate?
    var presentingVC: UIViewController?
    
    var exampleNumber: Int? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var icons: [String] = ["Correct.png", "Correct.png", "Warning.png"]
    var images: [String] = ["Fingers.png", "Password-Filled.png", "Artboard.png"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure() {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        acceptButton.tag = 100
        cancelButton.tag = 101
        acceptButton.addTarget(self, action: #selector(self.callDelegateResponder(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(self.callDelegateResponder(sender:)), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableCell")
        tableView.register(UINib(nibName: "ButtonsTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableCell")
        tableView.register(UINib(nibName: "ListTwoTableCell", bundle: nil), forCellReuseIdentifier: "ListTwoTableCell")
        tableView.register(UINib(nibName: "SortedTableCell", bundle: nil), forCellReuseIdentifier: "SortedTableCell")
        tableView.separatorStyle = .none
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
                if indexPath.row == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SortedTableCell", for: indexPath) as! SortedTableCell
                    cell.cellLabel.text = Utility.listTwo[indexPath.row]
                    cell.iconImageView.image = UIImage(named: icons[indexPath.row])
                    
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ListTwoTableCell", for: indexPath) as! ListTwoTableCell
                    cell.icon.image = UIImage(named: self.icons[indexPath.row])
                    cell.cellImageView.image = UIImage(named: self.images[indexPath.row])
                    cell.cellLabel.text = Utility.listTwo[indexPath.row]
                    return cell
                }
            }
        }else {
            //Cell implementation for buttons
            let cell = UITableViewCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 45
        }else {
            if exampleNumber == 2 || exampleNumber == 4 {
                let computedHeight = Utility.calculateHeightForString(inString: Utility.listOne[indexPath.row]) + 15
                return computedHeight > 65 ? computedHeight : 60
            }else {
                return 170
            }
        }
    }
    
    func callDelegateResponder(sender: UIButton) {
        presentingVC?.dismiss(animated: true, completion: { 
            self.buttonDelegate?.buttonPressed(sender: sender)
        })
    }
}
