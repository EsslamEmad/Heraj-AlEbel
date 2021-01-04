//
//  DashedBorderdRoundedCornerView.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 4/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit

@IBDesignable
class DashedBorderdRoundedCornerView: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor(hex: "CFCFCF") {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var dashSize: Int = 7 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var emptyDashSize: Int = 7 {
        didSet {
            setupView()
        }
    }
    
    var border: CAShapeLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setupView() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        border?.removeFromSuperlayer()
        border = CAShapeLayer()
        border?.strokeColor = borderColor.cgColor
        border?.lineDashPattern = [NSNumber(value: dashSize), NSNumber(value: emptyDashSize)]
        border?.frame = bounds
        border?.fillColor = nil
        border?.lineWidth = borderWidth
        border?.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.addSublayer(border!)
    }
    
}
