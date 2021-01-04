//
//  FlowManager.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 2/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SideMenuSwift

/// Responsible for the user flow inside the app
class FlowManager {
    
    static let shared = FlowManager()
    var window: UIWindow?
    
    init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    /// Switches current window to a specific view controller depending on user status
    func activateMainFlow() {
        if Defaults[.user] != nil {
            switchToMainFlow()
            
        } else {
            switchToLoginFlow()
        }
        
    }
    
    // MARK: - Private
    func switchToLoginFlow() {
        let loginVC = LoginViewController.nib()
        let navigationVC = BaseNavigationController.init(rootViewController: loginVC)
        self.window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }
    
    func switchToMainFlow() {
        let homeVC = HomeViewController.nib()
        let navigationVC = BaseNavigationController.init(rootViewController: homeVC)
        let sideMenuVC = SideMenuViewController.nib()
        let windowVC = SideMenuController(contentViewController: navigationVC, menuViewController: sideMenuVC)
        self.window?.rootViewController = windowVC
        window?.makeKeyAndVisible()
    }
    
}
