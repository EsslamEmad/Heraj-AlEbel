//
//  AdTableViewCell.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol AdTableViewCellDelegate: class {
    func didPressOnProduct(product: Product)
    func didPressOnEdit(product: Product)
    func didPressOnDelete(product: Product)
}

class AdTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var photosCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    var product: Product!
    weak var delegate: AdTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    func setupWith(product: Product){
        self.product = product
        if let img = product.photos?[0].thumb{
            if let url = URL(string: img){
                productImage.kf.setImage(with: url)
            }
        }
        if product.price != nil {
            priceLabel.text = String(product.price!) + " " + Localization.General.SRTitle}else {
                priceLabel.text = ""
            }
        photosCountLabel.text = String(product.photos.count)
        nameLabel.text = product.title
        cityLabel.text = product.city.name
        categoryLabel.text = product.category.title
        
    }
    
    @IBAction func didPressOnImage(_ gesture: UITapGestureRecognizer){
        delegate?.didPressOnProduct(product: product)
    }
    
    @IBAction func didPressEdit(_ sender: UIButton){
        self.delegate?.didPressOnEdit(product: product)
    }
    
    @IBAction func didPressDelete(_ sender: UIButton){
        self.delegate?.didPressOnDelete(product: product)
    }
    
}
