//
//  Utility.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/16/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit
import LocalAuthentication

class Utility {
    
    class var greenColor: UIColor {
        return UIColor(red: 0/255, green: 113/255, blue: 67/255, alpha: 1.0)
    }
    
    class var brownColor: UIColor {
        return UIColor(red: 45/255, green: 41/255, blue: 38/255, alpha: 1.0)
    }
    
    class var lightBrownColor: UIColor {
        return UIColor(red: 70/255, green: 63/255, blue: 59/255, alpha: 1.0)
    }
    
    class var listOne : [String]{
        return ["Coffee app does not have access to your fingerprints.", "Touch ID sign on retrives your password with you having to enter it.", "Any person with fingerprint registered on this device can sign on and access your Coffee app account."]
    }
    
    class var listTwo: [String] {
        return ["Coffee app does not have access to your fingerprints.", "Touch ID sign on retrives your password with you having to enter it.", "These people can sign in and access your account."]
    }
    
    //Func to calculate height for give string
    class func calculateHeightForString(inString:String) -> CGFloat {
        let messageString = inString
        let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: [NSFontAttributeName: UIFont(name: "Georgia", size: 20)!])
        let rect:CGRect = attrString!.boundingRect(with: CGSize(width: 200.0, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
        let requredSize:CGRect = rect
        return requredSize.height
        
    }
    
    class func showAlert(withTitle title: String?, withMessage message: String, from viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func invokeTouchId(from viewController: UIViewController, success authSuccess:@escaping (Bool)->Void) {
        let lacontext = LAContext()
        var error: NSError?
        
        if lacontext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            lacontext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Using touch Id to authenticate login", reply: { (authStatus, authError) in
                
                if authStatus {
                    //Login success show app home screen
                    DispatchQueue.main.async {
                        
                        authSuccess(true)
                        
                    }
                    
                }else {
                    authSuccess(false)
                    print(authError?.localizedDescription)
                    
                    switch (authError as! NSError).code {
                        
                    case LAError.systemCancel.rawValue:
                        DispatchQueue.main.async {
                            
                            self.showAlert(withTitle: "Error", withMessage: "Oops something went wrong. Please login using password.", from: viewController)
                        }
                        print("Authentication was cancelled by the system")
                        
                    case LAError.userCancel.rawValue:
                        print("Authentication was cancelled by the user")
                        
                    case LAError.userFallback.rawValue:
                        print("User selected to enter custom password")
                        
                    default:
                        print("Authentication failed")
                        OperationQueue.main.addOperation({ () -> Void in
                            //self.showPasswordAlert()
                        })
                    }
                }
            })
        }else {
            showAlert(withTitle: "Alert", withMessage: "Please set up Touch ID in settings to login with Touch ID.", from: viewController)
        }
    }
    
    class func addTouchView(to viewController: UIViewController, delegate: ButtonResponderDelegate, for example: Int) {
        let presentVC = UIViewController()
        if example == 1 {
            let touchView = Bundle.main.loadNibNamed("TermsView", owner: viewController, options: nil)?.first as? TermsView
            touchView?.configure()
            touchView?.responderDelegate = delegate
            touchView?.presentingVC = presentVC
            presentVC.modalPresentationStyle = .formSheet
            touchView?.frame = presentVC.view.bounds
            presentVC.view.addSubview(touchView!)
            viewController.present(presentVC, animated: true, completion: nil)
        }else {
            let touchView = Bundle.main.loadNibNamed("TouchView", owner: viewController, options: nil)?.first as? TouchView
            touchView?.frame = presentVC.view.bounds
            touchView?.configure()
            touchView?.buttonDelegate = delegate
            touchView?.exampleNumber = example
            touchView?.presentingVC = presentVC
            //touchView?.frame.origin.y = UIScreen.main.bounds.height
            //viewController.view.addSubview(touchView!)
            /*
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                touchView?.center.y = viewController.view.center.y
                }, completion: nil)
            //touchView?.touchAlertView.frame.size.width = UIScreen.main.bounds.width - 20
            */
            presentVC.modalPresentationStyle = .formSheet
            presentVC.view.addSubview(touchView!)
            viewController.present(presentVC, animated: true, completion: nil)
        }
 
            
    }
    
    class func getPassword(from viewController: UIViewController, success: @escaping (String?) -> Void) {
        var passField = UITextField()
        let alert = UIAlertController(title: "Touch ID was cancelled. Please enter password for authentication", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            passField = textField
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            success(passField.text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func startTimer() -> DispatchTime {
        
        return DispatchTime.now()
    }
    
    class func calculateTime(startTime: DispatchTime) -> Double {
        
        let endTime = DispatchTime.now()
        let time = Double((endTime.uptimeNanoseconds - startTime.uptimeNanoseconds)/1000)
        return time
    }
}

