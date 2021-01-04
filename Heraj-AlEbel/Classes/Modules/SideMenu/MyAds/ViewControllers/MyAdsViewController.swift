//
//  MyAdsViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class MyAdsViewController: BaseViewController{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MyAdsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMyAds()
    }
    
    func configureViewModel(){
        viewModel = MyAdsViewModel(view: self)
    }
    
    func fetchMyAds(){
        UIHelper.showLoading()
        viewModel.getMyAds()
    }
    
    func configureUI(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: AdTableViewCell.className, bundle: nil), forCellReuseIdentifier: AdTableViewCell.className)
    }
    
}

extension MyAdsViewController: MyAdsViewModelDelegate{
    func removeDidSucceed() {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: "تم حذف المنتج")
        tableView.reloadData()
    }
    
    func removeDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func getMyAdsDidSucceed() {
        UIHelper.hideLoading()
        tableView.reloadData()
    }
    
    func getMyAdsDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    
}


extension MyAdsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myAds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdTableViewCell.className) as! AdTableViewCell
        cell.setupWith(product: viewModel.myAds![indexPath.row])
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
        vc.viewModel.product = viewModel.myAds![indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension MyAdsViewController: AdTableViewCellDelegate{
    func didPressOnProduct(product: Product) {
        let vc = ProductViewController.nib()
        vc.viewModel = ProductViewModel(view: vc)
        vc.viewModel.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didPressOnEdit(product: Product) {
        let vc = AddProductViewController.nib()
        vc.edit = true
        vc.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didPressOnDelete(product: Product) {
        UIHelper.showLoading()
        viewModel.remove(product: product)
    }
    
    
    
    
}
