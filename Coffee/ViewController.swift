//
//  ViewController.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/16/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var joinNoButton: UIButton!
    
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        joinNoButton.layer.cornerRadius = 6
        signinButton.layer.cornerRadius = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

