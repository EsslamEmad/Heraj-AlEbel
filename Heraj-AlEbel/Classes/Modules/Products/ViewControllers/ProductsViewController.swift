//
//  ProductsViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 1/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class ProductsViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ProductsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }
    
    func configuration(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: ProductCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.className)
        self.title = viewModel.category?.title ?? ""
        UIHelper.showLoading()
        if let _ = viewModel.category{
            viewModel.fetchProducts()
        }else if let _ = viewModel.userID{
            viewModel.fetchProductsForUser()
        }else {
            viewModel.search()
        }
    }
    

}



//MARK: CollectionView Delegate and DataSource
extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
        cell.setupWith(product: viewModel!.products![indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIHelper.showLoading()
        let vc = ProductViewController.nib()
        vc.viewModel = ProductViewModel(view: vc)
        vc.viewModel.product = viewModel.products![indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 2 - 20 , height: 215)
    }
}


extension ProductsViewController: ProductsViewModelDelegate{
    func fetchProductsDidSucceed() {
        UIHelper.hideLoading()
        collectionView.reloadData()
        
    }
    func fetchProductsDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
}

extension ProductsViewController: ProductCollectionViewCellDelegate{
    func didPressOnProduct(product: Product) {
        
    }
    
    func didPressOnCall(product: Product) {
        guard Defaults[.user] != nil else {
            let vc = LoginViewController.nib()
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        guard let phoneNumber = product.user.phone else {
            return
        }
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func didPressOnChat(product: Product) {
        guard Defaults[.user] != nil else {
            let vc = LoginViewController.nib()
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        let chatVC = ChatViewController()
        let viewModel = ChatViewModel(view: chatVC, otherUser: product.user)
        chatVC.viewModel = viewModel
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
}
