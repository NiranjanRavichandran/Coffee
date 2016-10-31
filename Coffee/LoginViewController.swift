//
//  LoginViewController.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/16/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, ButtonResponderDelegate, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    
    @IBOutlet weak var touchIDButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var start: DispatchTime?
    var dialogTime: Double?
    var actionId = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cancelButton.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        self.signinButton.addTarget(self, action: #selector(self.signInUser), for: .touchUpInside)
        self.touchIDButton.addTarget(self, action: #selector(self.setUpTouchID(sender:)), for: .touchUpInside)
        self.navigationController?.navigationBar.isHidden = true
        
        if appdelegate.appDefaults.bool(forKey: "isTouchIDSet") == true {
            self.touchIDButton.setTitle("Sign In with Touch ID", for: .normal)
        }else {
            self.touchIDButton.setTitle("Set up Touch ID", for: .normal)
        }
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.text = appdelegate.userId
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if appdelegate.appDefaults.bool(forKey: "isLogin") == true {
            actionId = 2
        }else {
            actionId = 1
        }
    }
    
    func setUpTouchID(sender: UIButton) {
        start = Utility.startTimer()
        if self.usernameTextField.text == "" || self.usernameTextField.text != appdelegate.userId {
            Utility.showAlert(withTitle: "Error", withMessage: "Please enter the username to login using Touch ID", from: self)
        }else {
            if appdelegate.password == " " || appdelegate.userId != self.usernameTextField.text {
                self.getuserDetails(userID: self.usernameTextField.text!)
            }
            Utility.addTouchView(to: self, delegate: self, for: appdelegate.studyNumber)
        }
    }
    
    func signInUser() {
        start = Utility.startTimer()
        if self.usernameTextField.text == "" && self.passwordTextField.text == "" {
            //self.performSegue(withIdentifier: "HomeScreen", sender: self)
            Utility.showAlert(withTitle: "Error", withMessage: "Please enter username and password", from: self)
        }else {
            if appdelegate.userId == self.usernameTextField.text! && appdelegate.password == self.passwordTextField.text! {
                self.signInUserWithpass()
            }else {
                Utility.showAlert(withTitle: "Error", withMessage: "Invalid user credentials", from: self)
                self.getuserDetails(userID: self.usernameTextField.text!)
            }
        }
    }
    
    func signInUserWithpass() {
        //Validate user password
        self.actionId = 2
        let totalTime = Utility.calculateTime(startTime: start!)
        self.sendTimeToServer(withTime: totalTime, dialogTime: 0.0, isPass: 1)
        self.performSegue(withIdentifier: "HomeScreen", sender: self)
    }
    
    
    func buttonPressed(sender: UIButton) {
        let dialogTime = Utility.calculateTime(startTime: self.start!)
        if sender.tag == 100 {
            Utility.invokeTouchId(from: self, success: { authStatus in
                if authStatus {
                    self.appdelegate.appDefaults.set(true, forKey: "isTouchIDSet")
                    if self.appdelegate.studyNumber == 4 {
                        self.passwordTextField.alpha = 0.8
                        UIView.animate(withDuration: 2.0, animations: {
                            self.passwordTextField.alpha = 0.5
                            self.passwordTextField.text = "Password"
                            self.passwordTextField.alpha = 0.9
                            }, completion: { (_) in
                                self.sendTimeToServer(withTime: Utility.calculateTime(startTime: self.start!), dialogTime: dialogTime, isPass: 0)
                                
                                //Check if login
                                if self.appdelegate.appDefaults.bool(forKey: "isLogin") == false {
                                    self.appdelegate.appDefaults.set(true, forKey: "isLogin")
                                }
                                
                                self.performSegue(withIdentifier: "HomeScreen", sender: self)
                                
                        })
                    }else {
                        
                        self.sendTimeToServer(withTime: Utility.calculateTime(startTime: self.start!), dialogTime: dialogTime, isPass: 0)
                        
                        //Check if login
                        if self.appdelegate.appDefaults.bool(forKey: "isLogin") == false {
                            self.appdelegate.appDefaults.set(true, forKey: "isLogin")
                        }
                        
                        self.performSegue(withIdentifier: "HomeScreen", sender: self)
                    }
                }
            })
        }else {
            Utility.getPassword(from: self, success: { enteredPswd in
                //Validate user password
                if self.appdelegate.password == enteredPswd {
                    self.sendTimeToServer(withTime: Utility.calculateTime(startTime: self.start!), dialogTime: dialogTime, isPass: 1)
                    
                    //Check if login
                    if self.appdelegate.appDefaults.bool(forKey: "isLogin") == false {
                        self.appdelegate.appDefaults.set(true, forKey: "isLogin")
                    }
                    
                    self.performSegue(withIdentifier: "HomeScreen", sender: self)
                }
            })
        }
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func sendTimeToServer(withTime timeTaken: Double, dialogTime: Double, isPass: Int) {
        NetworkManager.sharedManager.saveTime(userID: appdelegate.userId, actionId: actionId, timeTaken: timeTaken, dialogTime: dialogTime, studyID: appdelegate.studyNumber, isPass: isPass) { (status) in
            if status {
                print("Time sent to server")
            }else {
                print("Failed to send time")
            }
        }
    }
    
    func getuserDetails(userID: String) {
        //If the reponse from the server is changed the app would crash here
        NetworkManager.sharedManager.getUser(forID: userID) { (user) in
            if user != nil {
                print(user)
                self.appdelegate.userId = (user!["user"] as! NSDictionary)["user_id"] as! String
                self.appdelegate.password = (user!["user"] as! NSDictionary)["password"] as! String
            }
        }
    }
}
