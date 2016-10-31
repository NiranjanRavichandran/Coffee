//
//  ReloadTableViewController.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/16/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class ReloadTableViewController: UITableViewController, ButtonResponderDelegate, UITextFieldDelegate, FourthResponder {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceField: UITextField!
    
    @IBOutlet weak var reloadButton: UIButton!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var startTime: DispatchTime?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissView))
        self.balanceLabel.text = "$\(appdelegate.currentBalance)"
        self.balanceField.delegate = self
        
    }
    
    func dismissView() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            //Call Touch View
//            if appdelegate.studyNumber != 4 {
            
            Utility.addTouchView(to: self, delegate: self, for: appdelegate.studyNumber)
            startTime = Utility.startTimer()

//            }else {
//                let fourthVC = storyboard?.instantiateViewController(withIdentifier: "FourthView") as! FourthViewController
//                fourthVC.sender = self
//                fourthVC.actionID = 4
//                self.present(fourthVC, animated: true, completion: nil)
//            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //Custom deleagtes
    func buttonPressed(sender: UIButton) {
        let dialogTime = Utility.calculateTime(startTime: startTime!)
        if sender.tag == 100 {
            Utility.invokeTouchId(from: self, success: { authStatus in
                if authStatus {
                    if self.appdelegate.studyNumber == 4 {
                        let fourthVC = self.storyboard?.instantiateViewController(withIdentifier: "FourthView") as! FourthViewController
                        self.present(fourthVC, animated: true, completion: nil)
                    }
                    self.addBalance()
                    self.sendTimeToServer(withTime: Utility.calculateTime(startTime: self.startTime!), dialogTime: dialogTime, isPass: 0)
                    
                }
            })
        }else {
            Utility.getPassword(from: self, success: { enteredPswd in
                
                self.addBalance()
                self.sendTimeToServer(withTime: Utility.calculateTime(startTime: self.startTime!), dialogTime: dialogTime, isPass: 1)
            })
        }
    }
    
    func addBalance() {
        var message = "Your card is now reloaded with $25"
        if self.balanceField.text != "" {
            message = "Your card is now reloaded with $\(self.balanceField.text!)"
            self.appdelegate.currentBalance += Int(self.balanceField.text!)!
        }else {
            self.appdelegate.currentBalance += 25
        }
        Utility.showAlert(withTitle: "Success", withMessage: message, from: self)
        
        self.balanceLabel.text = "$\(self.appdelegate.currentBalance)"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            let reloadText = "Reload $\(Int(self.balanceField.text!)!)"
            reloadButton.setTitle(reloadText, for: .normal)
        }
    }
    
    func sendTimeToServer(withTime timeTaken: Double, dialogTime: Double, isPass: Int) {
        NetworkManager.sharedManager.saveTime(userID: appdelegate.userId, actionId: 4, timeTaken: timeTaken, dialogTime: dialogTime, studyID: appdelegate.studyNumber, isPass: isPass) { (status) in
            if status {
                print("Time sent to server")
            }else {
                print("Failed to send time")
            }
        }
    }
    
    func authenticateSuccess() {
        addBalance()
    }
}
