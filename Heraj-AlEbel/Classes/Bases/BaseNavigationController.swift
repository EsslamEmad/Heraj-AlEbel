//
//  BaseNavigationController.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 2/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit
import Hero

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor(red: 222/255, green: 179/255, blue: 12/255, alpha: 1)
        navigationBar.tintColor = UIColor.white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = textAttributes
        self.hero.isEnabled = true
        self.hero.navigationAnimationType = .selectBy(presenting:.zoomSlide(direction: .down), dismissing:.zoomSlide(direction: .up))
        self.hero.modalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
    }
    
}
