//
//  AppDelegate+UN.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 21/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import SwiftyUserDefaults
import SideMenuSwift
import SwiftEntryKit
import FirebaseMessaging

extension AppDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
    
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        
        guard let notificationTypeString = userInfo["gcm.notification.type"] as? String else { return }
        guard let idString = userInfo["id"] as? String,
            let id = Int(idString) else { return }
       // guard let productIDString = userInfo["gcm.notification.product_id"] as? String,
         //   let productID = Int(productIDString) else { return }
        guard let notificationTypeInt = Int(notificationTypeString) else { return }
        
        switch notificationTypeInt{
        case 1:
            presentProduct(forOrderID: id)
        case 2:
            presentChat(forUserID: id)
        default:
            break
        }
        completionHandler()
        
    }
    
    
    
    // MARK: - Helpers
   
    
    private func presentProduct(forOrderID productID: Int) {
        UIHelper.showLoading()
        fetchProductByID(productID) { (product) in
            UIHelper.hideLoading()
            guard let product = product else { return }
            let vc = ProductViewController.nib()
            vc.viewModel = ProductViewModel(view: vc)
            vc.viewModel.product = product
            FlowManager.shared.switchToMainFlow()
            let sideMenuController = UIApplication.shared.keyWindow?.rootViewController as? SideMenuController
            let navController = sideMenuController?.contentViewController as? BaseNavigationController
            navController?.pushViewController(vc, animated: true)
        }
        
    }
    
    private func presentChat(forUserID userID: Int) {
        UIHelper.showLoading()
        fetchUserByID(userID) { (user) in
            UIHelper.hideLoading()
            guard let user = user else { return }
            let vc = ChatViewController()
            vc.viewModel = ChatViewModel(view: vc, otherUser: user)
            FlowManager.shared.switchToMainFlow()
            let sideMenuController = UIApplication.shared.keyWindow?.rootViewController as? SideMenuController
            let navController = sideMenuController?.contentViewController as? BaseNavigationController
            navController?.pushViewController(vc, animated: true)
        }
    }
    
    func fetchProductByID(_ productID: Int, completion: @escaping (Product?) -> Void){
        RequestManager.shared.performRequest(withRoute: HomeEndPoint.getProduct(prodID: productID), responseModel: Product.self){(result) in
            switch result {
            case .success(let product):
                completion(product)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func fetchUserByID(_ userID: Int, completion: @escaping (User?) -> Void){
        RequestManager.shared.performRequest(withRoute: HomeEndPoint.getUser(id: userID), responseModel: User.self){(result) in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
   
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        /*if let id = Defaults[.user]?.id {
            RequestManager.shared.performRequest(withRoute: AuthenticationEndpoint.editUser(userID: id, name: nil, phoneNumber: nil, email: nil, password: nil, photoUrl: nil, token: fcmToken), responseModel: User.self) { (result) in
                switch result {
                case .success(let user):
                    Defaults[.user] = user
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }*/
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
}

