//
//  AdsViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 28/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import Kingfisher

class AdsViewController: UIViewController {

    var viewModel: AdsViewModel!
    var homeViewModel: HomeViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureUI()
    }
    
    func configureViewModel(){
        viewModel = AdsViewModel(view: self)
       // homeViewModel = HomeViewModel(view: self)
    }
    
    func configureUI(){
        self.title = Localization.Ads.ScreenTitle
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CategoryAdsTableViewCell.className, bundle: nil), forCellReuseIdentifier: CategoryAdsTableViewCell.className)
    }
    
    @IBAction func didPressOnAddButton(_ sender: UIButton){
        
    }
}

//MARK: ads view model delegate
extension AdsViewController: AdsViewModelDelegate{
    
}

//MARK: TableView Delegate and DataSource
extension AdsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryAdsTableViewCell.className, for: indexPath) as! CategoryAdsTableViewCell
        cell.index = indexPath.row
        cell.delegate = self
        switch indexPath.row{
        case 0:
            cell.setupWith(products: viewModel.data?.latestProducts ?? [Product]())
        case 1:
            cell.setupWith(products: viewModel.data?.general ?? [Product]())
        case 2:
            cell.setupWith(products: viewModel.data?.mazayen ?? [Product]())
        case 3:
            cell.setupWith(products: viewModel.data?.hagn ?? [Product]())
        case 4:
            cell.setupWith(products: viewModel.data?.zabh ?? [Product]())
        case 5:
            cell.setupWith(products: viewModel.data?.other ?? [Product]())
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let img = viewModel.data?.banner, let url = URL(string: img) else {
            print(0)
            return nil
        }
        let myCustomView = UIImageView()
        myCustomView.kf.setImage(with: url)
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.addSubview(myCustomView)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}

//Mark: Home ViewModel Delegate
extension AdsViewController: HomeViewModelDelegate{
    func fetchRestaurantsDidSucceed() {
        
    }
    
    func fetchRestaurantsDidFailWithError(_ error: Error) {
        
    }
    
    func fetchCategoriesDidSucceed() {
        
    }
    
    func fetchCategoriesDidFailWithError(_ error: Error) {
        
    }
    
    func getBannersDidSucceed() {
        
    }
    
    func fetchDataDidFailWithError(_ error: Error) {
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func fetchDataDidSucceed() {
        print(111)
        viewModel.data = homeViewModel.data
        tableView.reloadData()
    }
}


//MARK:- Categories TableViewCell Delegate
extension AdsViewController: CategoryAdsTableViewCellDelegate{
    func didTapWatchAll(index: Int) {
        
    }
    func didTapOnProduct(product: Product) {
        
    }
}

