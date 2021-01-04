//
//  CollectionSeparatorView.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 16/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import Foundation

import UIKit

class CollectionSeparatorView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "999999")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        frame = layoutAttributes.frame
    }
    
}
