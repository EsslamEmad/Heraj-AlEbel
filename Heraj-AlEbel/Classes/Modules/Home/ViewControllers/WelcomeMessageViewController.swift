//
//  WelcomeMessageViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 10/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftEntryKit

class WelcomeMessageViewController: UIViewController {

    var msg: String!
    
    @IBOutlet weak var msgLabel: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        msgLabel.text = msg
    }
    

    @IBAction func didPressOK(_ sender: UIButton){
        SwiftEntryKit.dismiss()
    }

}
