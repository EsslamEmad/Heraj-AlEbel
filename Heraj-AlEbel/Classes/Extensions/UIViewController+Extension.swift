//
//  UIViewController+Extension.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 2/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
    
    public class func nib() -> Self {
        return self.init(nibName: self.className, bundle: nil)
    }
    
}


