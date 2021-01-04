//
//  CALayer+Extension.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 4/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit

extension CALayer {
    
    func animateBorderColor(from startColor: UIColor, to endColor: UIColor, withDuration duration: Double) {
        let colorAnimation = CABasicAnimation(keyPath: "borderColor")
        colorAnimation.fromValue = startColor.cgColor
        colorAnimation.toValue = endColor.cgColor
        colorAnimation.duration = duration
        self.borderColor = endColor.cgColor
        self.add(colorAnimation, forKey: "borderColor")
    }
}
