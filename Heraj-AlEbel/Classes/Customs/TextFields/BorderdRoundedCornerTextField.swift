//
//  BorderdRoundedCornerTextField.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 3/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class BorderdRoundedCornerTextField: UITextField {
    
    @IBInspectable var iconImage: UIImage? {
        didSet {
            setupView()
        }
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: bounds.midY - 10, width: 20, height: 20))
        // TODO: Handle
        //        if LanguageHandler.languageIsArabic() {
        //            imageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        //        }
        imageView.image = iconImage
        imageView.tintColor = UIColor(hex: "999999")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    private func setupView() {
        borderStyle = .none
        clipsToBounds = true
        tintColor = UIColor.themeColor
        layer.cornerRadius = 10
        layer.borderColor = UIColor.themeColor.cgColor
        layer.borderWidth = 1
        backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        if iconImageView.superview == nil {
            iconImageView.image = iconImage
            iconImageView.alpha = 1
            self.addSubview(iconImageView)
        }
        font = UIFont(name: FontNames.BahijSemiBold, size: 13)!
    }
    
    // TODO: Add animation
    
    override func becomeFirstResponder() -> Bool {
        setActive()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        setInactive()
        return super.resignFirstResponder()
    }
    
    // TODO: Tidy up
    private func setActive() {
        UIView.animate(withDuration: 0.3) {
            self.iconImageView.tintColor = UIColor.themeColor
        }
        layer.animateBorderColor(from: UIColor(hex: "999999"), to: UIColor.themeColor, withDuration: 0.3)
    }
    
    private func setInactive() {
        UIView.animate(withDuration: 0.5) {
            self.iconImageView.tintColor = UIColor(hex: "999999")
        }
        layer.animateBorderColor(from: UIColor.themeColor, to: UIColor(hex: "999999"), withDuration: 0.3)
    }
    
    private func hasIconImage() -> Bool {
        if iconImage == nil { return false }
        else { return true }
    }
    
    private func getTextRect() -> CGRect {
        if hasIconImage() {
            return bounds.inset(by: UIEdgeInsets(top: 4, left: 40, bottom: 0, right: 15))
        }
        else {
            return bounds.inset(by: UIEdgeInsets(top: 4, left: 13, bottom: 0, right: 15))
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // TODO: Handle RTL
        if hasIconImage() {
            return bounds.inset(by: UIEdgeInsets(top: 4, left: 40, bottom: 0, right: 15))
        }
        else {
            return bounds.inset(by: UIEdgeInsets(top: 4, left: 13, bottom: 0, right: 15))
        }
        // return getTextRect()
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        // TODO: Handle RTL
        return getTextRect()
    }
}

