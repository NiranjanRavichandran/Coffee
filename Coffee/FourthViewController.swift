//
//  FourthViewController.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/26/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

protocol FourthResponder {
    func authenticateSuccess()
}

class FourthViewController: UIViewController, ButtonResponderDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var touchIDButton: UIButton!
    
    var sender: FourthResponder?
    var startTime: DispatchTime?
    var actionID: Int = 3
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.text = appdelegate.userId
//        usernameField.delegate = self
//        passwordField.delegate = self
//        signInButton.addTarget(self, action: #selector(self.signInUsingPass), for: .touchUpInside)
//        self.cancelButton.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
//        self.touchIDButton.addTarget(self, action: #selector(self.showTouchID), for: .touchUpInside)
//        self.usernameField.text = appdelegate.userId
        
        UIView.animate(withDuration: 2, animations: {
            //Password field animation
            self.passwordField.alpha = 0.5
            self.passwordField.text = "Password"
            self.passwordField.alpha = 0.9
            }, completion: { (_) in
                
                self.dismiss(animated: true, completion: nil)
                
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //********Implementation after this is not used*********
    
    func signInUsingPass() {
        startTime = Utility.startTimer()
        if usernameField.text != "" && passwordField.text != "" {
            if usernameField.text! == appdelegate.userId && passwordField.text! == appdelegate.password {
                self.dismiss(animated: true) {
                    self.sender?.authenticateSuccess()
                    self.sendTimeToServer(withTime: Utility.calculateTime(startTime: self.startTime!), dialogTime: 0.0, isPass: 1)
                }
            }
            
        }else {
            Utility.showAlert(withTitle: "Error", withMessage: "Please enter user ID and password", from: self)
        }
    }
    
    func showTouchID() {
        startTime = Utility.startTimer()
        Utility.addTouchView(to: self, delegate: self, for: appdelegate.studyNumber)
    }
    
    func sendTimeToServer(withTime timeTaken: Double, dialogTime: Double, isPass: Int) {
        NetworkManager.sharedManager.saveTime(userID: appdelegate.userId, actionId: actionID, timeTaken: timeTaken, dialogTime: dialogTime, studyID: appdelegate.studyNumber, isPass: isPass) { (status) in
            if status {
                print("Time sent to server")
            }else {
                print("Failed to send time")
            }
        }
    }
    
    func buttonPressed(sender: UIButton) {
        let dialogTime = Utility.calculateTime(startTime: startTime!)
        if sender.tag == 100 {
            Utility.invokeTouchId(from: self, success: { authStatus in
                if authStatus {
                    self.sendTimeToServer(withTime: Utility.calculateTime(startTime: self.startTime!), dialogTime: dialogTime, isPass: 0)
                    UIView.animate(withDuration: 1.5, animations: {
                        //Password field animation
                        self.passwordField.alpha = 0.5
                        self.passwordField.text = "Password"
                        self.passwordField.alpha = 0.9
                        }, completion: { (_) in
                            
                            self.dismissView()
                            self.sender?.authenticateSuccess()
                    })
                }
            })
            
        }else {
            
            Utility.getPassword(from: self, success: { enteredPswd in
                
                if enteredPswd == self.appdelegate.password {
                
                    self.sendTimeToServer(withTime: Utility.calculateTime(startTime: self.startTime!), dialogTime: dialogTime, isPass: 1)
                    self.dismissView()
                    self.sender?.authenticateSuccess()
                }else {
                    Utility.showAlert(withTitle: "Error", withMessage: "Please enter correct password", from: self)
                }
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
