//
//  ProductPhotoCollectionViewCell.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class ProductPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var deleteButton: UIImageView!
    
    override func awakeFromNib() {
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
    }
    
    func setupWith(img: UIImage){
        photo.image = img
    }
}
