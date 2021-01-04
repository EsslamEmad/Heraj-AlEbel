//
//  CategoriesViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 28/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CategoriesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureViewModel()
        configureUI()
        fetchData()
    }
    
    func configureViewModel(){
        viewModel = CategoriesViewModel(view: self)
        
    }
    
    func configureUI(){
        self.title = Localization.Categories.ScreenTitle
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CategoryTableViewCell.className, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.className)
    }
    
    func fetchData(){
        viewModel?.fetchCategories()
    }

    

}


extension CategoriesViewController: CategoriesViewModelDelegate{
    func fetchCategoriesDidSucceed() {
        UIHelper.hideLoading()
        tableView.reloadData()
    }
    func fetchCategoriesDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
}


extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((viewModel?.filteredCategories.count ?? 0) + 1) / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.className) as! CategoryTableViewCell
        cell.delegate = self
        cell.button1.setTitle(viewModel!.filteredCategories[indexPath.row * 2].title, for: .normal)
        cell.button1.tag = indexPath.row * 2
        guard viewModel!.filteredCategories.count > (indexPath.row * 2 + 1) else {
            cell.view2.isHidden = true
            return cell
        }
        cell.button2.setTitle(viewModel!.filteredCategories[indexPath.row * 2 + 1].title, for: .normal)
        cell.button2.tag = indexPath.row * 2 + 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}


extension CategoriesViewController: CategoryTableViewCellDelegate{
    func didPressOnCategory(index: Int) {
        let category = viewModel?.filteredCategories[index]
        if viewModel?.parentID == 0 && (category!.id < 4 || category!.id > 5) {
            let vc = CategoriesViewController.nib()
            vc.viewModel = CategoriesViewModel(view: vc)
            vc.viewModel?.parentID = category!.id
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = ProductsViewController.nib()
            vc.viewModel = ProductsViewModel(view: vc)
            vc.viewModel?.category = category!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

