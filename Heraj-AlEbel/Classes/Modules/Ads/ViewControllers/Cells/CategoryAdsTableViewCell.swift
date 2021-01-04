//
//  CategoryAdsTableViewCell.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 28/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
protocol CategoryAdsTableViewCellDelegate: class {
    func didTapWatchAll(index: Int)
    func didTapOnProduct(product: Product)
}

class CategoryAdsTableViewCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var watchAllButton: UIButton!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var products: [Product]!
    weak var delegate: CategoryAdsTableViewCellDelegate?
    var index: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        watchAllButton.setTitle(Localization.Ads.watchAllButtonTitle, for: .normal)
    }
    
    func setupWith(products: [Product]){
        self.products = products
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.register(UINib(nibName: ProductCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.className)
        productsCollectionView.reloadData()
        switch index{
        case 0:
            titleLabel.text = Localization.Categories.latestProducts
        case 1:
            titleLabel.text = Localization.Categories.general
        case 2:
            titleLabel.text = Localization.Categories.mazayen
        case 3:
            titleLabel.text = Localization.Categories.hagn
        case 4:
            titleLabel.text = Localization.Categories.zabh
        case 5:
            titleLabel.text = Localization.Categories.others
        default: break
        }
    }
    
    @IBAction func didPressOnWatchAll(_ sender: UIButton){
        delegate?.didTapWatchAll(index: index)
    }
}

extension CategoryAdsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
        cell.setupWith(product: products[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension CategoryAdsTableViewCell: ProductCollectionViewCellDelegate{
    func didPressOnCall(product: Product) {
        
    }
    
    func didPressOnChat(product: Product) {
        
    }
    
    func didPressOnProduct(product: Product) {
        delegate?.didTapOnProduct(product: product)
    }
}
