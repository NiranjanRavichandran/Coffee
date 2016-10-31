//
//  HomeViewController.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/16/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ButtonResponderDelegate, FourthResponder {

    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cupsImageView: UIImageView!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var paymentView: PaymentView?
    var startTime: DispatchTime?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.starCountLabel.layer.cornerRadius = 5
        self.starCountLabel.clipsToBounds = true
        self.logoutButton.addTarget(self, action: #selector(self.logoutUser), for: .touchUpInside)
        self.payButton.addTarget(self, action: #selector(self.showPaymentView), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func logoutUser() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func showPaymentView() {
        if paymentView == nil {
            paymentView = Bundle.main.loadNibNamed("PaymentView", owner: self, options: nil)?.first as? PaymentView
            paymentView?.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width - 10, height: self.view.bounds.height - 90)
            paymentView?.configure(sender: self)
            paymentView?.center.x = self.view.center.x
            paymentView?.layer.cornerRadius = 6
            paymentView?.clipsToBounds = true
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.paymentView?.frame.origin.y = 90
                }, completion: nil)
            paymentView?.manageButton.addTarget(self, action: #selector(self.showReloadView), for: .touchUpInside)
            //paymentView?.payButton.addTarget(self, action: #selector(self.payButtonPressed), for: .touchUpInside)
            paymentView?.viewBalanceButton.addTarget(self, action: #selector(self.payButtonPressed), for: .touchUpInside)
            self.view.addSubview(paymentView!)
            self.showBalance()
        }else {
            UIView.animate(withDuration: 0.5, animations: { 
                self.paymentView?.frame.origin.y = self.view.bounds.height
                }, completion: { (_) in
                    self.paymentView = nil
            })
        }

    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let velocity  = recognizer.velocity(in: paymentView)
        if velocity.y < 0 {
            //paymentView?.frame.origin.y += velocity.y
        }
        
    }
    
    func showReloadView() {
        self.performSegue(withIdentifier: "ReloadView", sender: self)
    }
    
    func payButtonPressed() {
//        if appdelegate.studyNumber != 4 {
            Utility.addTouchView(to: self, delegate: self, for: appdelegate.studyNumber)
            startTime = Utility.startTimer()
//        }else {
//            let fourthVC = storyboard?.instantiateViewController(withIdentifier: "FourthView") as! FourthViewController
//            fourthVC.sender = self
//            fourthVC.actionID = 3
//            self.present(fourthVC, animated: true, completion: nil)
//        }
    }
    
    func buttonPressed(sender: UIButton) {
        let dialogTime = Utility.calculateTime(startTime: startTime!)
        if sender.tag == 100 {
            Utility.invokeTouchId(from: self, success: { authStatus in
                if authStatus {
                    
                    if self.appdelegate.studyNumber == 4 {
                        let fourthVC = self.storyboard?.instantiateViewController(withIdentifier: "FourthView") as! FourthViewController
                        self.present(fourthVC, animated: true, completion: nil)
                    }
                    self.showTranscations()
                    self.sendTimeToServer(withTime: Utility.calculateTime(startTime: self.startTime!), dialogTime: dialogTime, isPass: 0)
                }
            })
        }else {
            Utility.getPassword(from: self, success: { enteredPswd in
                if enteredPswd == self.appdelegate.password {
                    self.showTranscations()
                    self.sendTimeToServer(withTime: Utility.calculateTime(startTime: self.startTime!), dialogTime: dialogTime, isPass: 1)
                }
            })
        }
    }
    
    func showBalance() {
        self.paymentView?.balanceLabel.text = "$\(self.appdelegate.currentBalance)"
        self.paymentView?.balanceLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
        UIView.animate(withDuration: 1, animations: {
            self.paymentView?.balanceLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func showTranscations() {
        UIView.animate(withDuration: 0.5) { 
            self.paymentView?.tableView.alpha = 1
        }
    }
    
    func sendTimeToServer(withTime timeTaken: Double, dialogTime: Double, isPass: Int) {
        NetworkManager.sharedManager.saveTime(userID: appdelegate.userId, actionId: 3, timeTaken: timeTaken, dialogTime: dialogTime, studyID: appdelegate.studyNumber, isPass: isPass) { (status) in
            if status {
                print("Time sent to server")
            }else {
                print("Failed to send time")
            }
        }
    }
    
    func authenticateSuccess() {
        self.showTranscations()
    }

}
