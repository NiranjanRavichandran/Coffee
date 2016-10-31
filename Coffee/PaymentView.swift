//
//  PaymentView.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/16/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class PaymentView: UIView, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var manageButton: UIButton!
    @IBOutlet weak var viewBalanceButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var panGesture: UIPanGestureRecognizer!
    var listOne = ["Chocolate Smoothe", "Cafe Misto", "Iced Tea"]
    var listTwo = ["$4.75", "$3.98", "$2.89"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //configure()
    }
    
    func configure(sender: UIViewController) {
        viewBalanceButton.layer.cornerRadius = 6
        panGesture = UIPanGestureRecognizer(target: sender, action: #selector(HomeViewController.handlePan(recognizer:)))
        self.addGestureRecognizer(panGesture)
        cardImageView.layer.cornerRadius = 6
        cardImageView.clipsToBounds = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor.clear
        tableView.layer.cornerRadius = 6
        tableView.clipsToBounds = true
        tableView.alpha = 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTwo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.textColor = Utility.brownColor
        cell.detailTextLabel?.textColor = Utility.lightBrownColor
        cell.textLabel?.text = listOne[indexPath.row]
        cell.detailTextLabel?.text = listTwo[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
