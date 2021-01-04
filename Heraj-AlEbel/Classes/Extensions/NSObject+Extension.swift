//
//  NSObject+Extension.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 2/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import Foundation

public extension NSObject {
    
    class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
}
