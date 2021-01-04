//
//  FavoritesViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController{

    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: FavoritesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureUI()
        fetchFavorites()
    }
    
    func configureViewModel(){
        viewModel = FavoritesViewModel(view: self)
    }
    
    func fetchFavorites(){
        UIHelper.showLoading()
        viewModel.getFavorites()
    }
    
    func configureUI(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: FavoriteTableViewCell.className, bundle: nil), forCellReuseIdentifier: FavoriteTableViewCell.className)
    }
    
}

extension FavoritesViewController: FavoritesViewModelDelegate{
    func removeFromFavoritesDidSucceed() {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: "تم حذف المنتج من قائمة المفضلة")
        tableView.reloadData()
    }
    
    func removeFromFavoritesDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func getFavoritesDidSucceed() {
        UIHelper.hideLoading()
        tableView.reloadData()
    }
    
    func getFavoritesDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    
}


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.className) as! FavoriteTableViewCell
        cell.setupWith(product: viewModel.favorites![indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIHelper.showLoading()
        let vc = ProductViewController.nib()
        vc.viewModel = ProductViewModel(view: vc)
        vc.viewModel.product = viewModel.favorites![indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension FavoritesViewController: FavoriteTableViewCellDelegate{
    func didPressOnProduct(product: Product) {
        let vc = ProductViewController.nib()
        vc.viewModel = ProductViewModel(view: vc)
        vc.viewModel.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didPressOnCall(product: Product) {
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
        let chatVC = ChatViewController()
        let viewModel = ChatViewModel(view: chatVC, otherUser: product.user)
        chatVC.viewModel = viewModel
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func didPressOnFavorite(product: Product) {
        UIHelper.showLoading()
        viewModel.removeFromFavorite(product: product)
    }
    
    
}
