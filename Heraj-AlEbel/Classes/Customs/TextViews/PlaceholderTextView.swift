//
//  PlaceholderTextView.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 11/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit

@IBDesignable
class PlaceholderTextView: UITextView, UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    @IBInspectable var placeholder: String? {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderdAndRounded: Bool = true {
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
    
    private func setupView() {
        if borderdAndRounded {
            layer.cornerRadius = 15
            layer.borderColor = UIColor(hex: "CFCFCF").cgColor
            layer.borderWidth = 1
        } else {
            layer.cornerRadius = 0
            layer.borderWidth = 0
        }
        clipsToBounds = true
        layer.masksToBounds = true
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
            resizePlaceholder()
        } else {
            addPlaceholder(placeholder)
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding + 8
            let labelY = self.textContainerInset.top + 4
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String?) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.numberOfLines = 0
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray.withAlphaComponent(0.6)
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

