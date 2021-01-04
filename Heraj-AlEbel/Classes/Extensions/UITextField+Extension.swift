//
//  UITextField+Extension.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 4/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

extension UITextField{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .numberPad && string != "" {
            let numberStr: String = string
            let formatter: NumberFormatter = NumberFormatter()
            formatter.locale = Locale(identifier: "EN")
            if let final = formatter.number(from: numberStr) {
                textField.text =  "\(textField.text ?? "")\(final)"
            }
            return false
        }
        return true
    }
}
