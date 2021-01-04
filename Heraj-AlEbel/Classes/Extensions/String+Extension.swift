//
//  String+Extension.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 4/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
}
