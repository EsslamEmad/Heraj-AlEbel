//
//  CategoryCollectionViewCell.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 7/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit
import Kingfisher

class FoursquareCategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var logoImageView: CircularImageView!
    //@IBOutlet weak var borderView: BorderdCircularView!
    
    // MARK: - Setup
    
    
    func setupWith(category: Category) {
        nameLabel.text = category.title
        nameLabel.layer.cornerRadius = 10.0
        nameLabel.clipsToBounds = true
        /*  if let urlString = category.photo , let imageURL = URL(string: urlString) {
         logoImageView.kf.indicatorType = .activity
         logoImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.2))])
         }*/
        if category.isSelected == true {
            //borderView.borderColor = UIColor.themeOrange
            nameLabel.backgroundColor = UIColor.themeColor
        } else {
            //borderView.borderColor = UIColor.borderGray
            nameLabel.backgroundColor = UIColor(hex: "999999")
        }
    }

}
