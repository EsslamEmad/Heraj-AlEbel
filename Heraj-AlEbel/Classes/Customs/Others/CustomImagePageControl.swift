//
//  CustomImagePageControl.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 3/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit

@IBDesignable
class CustomImagePageControl: UIPageControl {
    
    @IBInspectable var currentPageImage: UIImage? {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var otherPagesImage: UIImage? {
        didSet {
            setupView()
        }
    }
    
    override var numberOfPages: Int {
        didSet {
            setupView()
        }
    }
    
    override var currentPage: Int {
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
        
        pageIndicatorTintColor = .clear
        currentPageIndicatorTintColor = .clear
        clipsToBounds = false
        
        transform = CGAffineTransform(scaleX: 3, y: 1)
        
        for (index, subview) in subviews.enumerated() {
            let imageView: UIImageView
            if let existingImageview = getImageView(forSubview: subview) {
                imageView = existingImageview
            } else {
                imageView = UIImageView(image: otherPagesImage)
                
                imageView.center = subview.center
                subview.addSubview(imageView)
                subview.clipsToBounds = false
            }
            imageView.image = currentPage == index ? currentPageImage : otherPagesImage
            subview.transform = CGAffineTransform(scaleX: 1/3, y: 1)
        }
    }
    
    private func getImageView(forSubview view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
                } as? UIImageView
            
            return view
        }
    }
}
