//
//  TermsView.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/17/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class TermsView: UIView {

    @IBOutlet weak var acceptButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!
    
    var responderDelegate: ButtonResponderDelegate?
    var presentingVC: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure() {
        acceptButton.tag = 100
        cancelButton.tag = 101
        acceptButton.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .touchUpInside)
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
    
    func buttonPressed(sender: UIButton) {
        presentingVC?.dismiss(animated: true, completion: { 
            self.responderDelegate?.buttonPressed(sender: sender)
        })
    }
    
    
}
