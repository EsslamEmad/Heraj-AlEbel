//
//  UIHelper.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 4/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UIHelper: NSObject {
    
    static var currentViewController: UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    class func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: Localization.General.AppName,
                                           message: message,
                                           preferredStyle: .alert)
        let okAction = UIAlertAction(title: Localization.General.OkActionTitle, style: .cancel, handler: nil)
        alert.addAction(okAction)
        currentViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func showLoading(_ message: String = "") {
        let size = CGSize.init(width: 30, height: 30)
        currentViewController?.startAnimating(size,
                                              message: "",
                                              messageFont: nil,
                                              type: NVActivityIndicatorType.circleStrokeSpin)
    }
    
    static func hideLoading() {
        currentViewController?.stopAnimating()
    }
    
}
