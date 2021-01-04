//
//  FavoriteTableViewCell.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol FavoriteTableViewCellDelegate: class {
    func didPressOnProduct(product: Product)
    func didPressOnCall(product: Product)
    func didPressOnChat(product: Product)
    func didPressOnFavorite(product: Product)
}

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var photosCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    var product: Product!
    weak var delegate: FavoriteTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        callButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        chatButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

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
        callButton.alpha = 1
        callButton.alpha = 1
        if product.userID == Defaults[.user]!.id{
            callButton.alpha = 0
            chatButton.alpha = 0
        }
        if !product.showPhone{
            callButton.alpha = 0
        }
    }
    
    @IBAction func didPressOnImage(_ gesture: UITapGestureRecognizer){
        delegate?.didPressOnProduct(product: product)
    }
    
    @IBAction func didPressCall(_ sender: UIButton){
        self.delegate?.didPressOnCall(product: product)
    }
    
    @IBAction func didPressChat(_ sender: UIButton){
        self.delegate?.didPressOnChat(product: product)
    }
    
    @IBAction func didPressFavorite(_ sender: UIButton){
        self.delegate?.didPressOnFavorite(product: product)
    }
}
