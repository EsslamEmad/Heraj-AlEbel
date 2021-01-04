//
//  RoundedCornerButton.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 3/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornerButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
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
    
    func setupView() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
}

