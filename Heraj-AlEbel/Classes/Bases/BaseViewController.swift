//
//  BaseViewController.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 2/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit
import Hero

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // TODO: Change color
        view.backgroundColor = UIColor.white
        self.hero.isEnabled = true

    }
    
}
