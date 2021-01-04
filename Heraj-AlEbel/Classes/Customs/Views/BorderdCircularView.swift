//
//  BorderdCircularView.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 7/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit

@IBDesignable
class BorderdCircularView: CircularView {
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.borderGray {
        didSet {
            setupView()
        }
    }
    
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
    
    override func setupView() {
        super.setupView()
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
}

