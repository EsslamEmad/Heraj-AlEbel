//
//  AppDelegate.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 21/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SideMenuSwift
import Firebase
import FirebaseMessaging
import SwiftyUserDefaults


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Defaults[.user] = nil
        setupSDKs(withApplication: application)
        FlowManager.shared.activateMainFlow()
        return true
        
    }
    
}

extension AppDelegate {
    
    private func setupSDKs(withApplication application: UIApplication) {
        // IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20.0
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // Side Menu
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.size.width * 0.75
        SideMenuController.preferences.basic.defaultCacheKey = "0"
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.statusBarBehavior = .none
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        
        // Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
       
    }
    
}

