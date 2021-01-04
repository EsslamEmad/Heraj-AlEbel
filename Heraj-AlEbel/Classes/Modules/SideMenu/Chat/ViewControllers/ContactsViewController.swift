//
//  ContactsViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ContactsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureUI()
        getContacts()
    }
    
    func configureViewModel(){
        viewModel = ContactsViewModel(view: self)
    }
    
    func configureUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ContactTableViewCell.className, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.className)
        self.title = "الشات"
    }
    
    func getContacts(){
        UIHelper.showLoading()
        viewModel.getContacts()
    }
    

}

extension ContactsViewController: ContactsViewModelDelegate{
    func getContactsDidSucceed() {
        UIHelper.hideLoading()
        tableView.reloadData()
    }
    func getContactsDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
}


extension ContactsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.className) as! ContactTableViewCell
        cell.setupWith(conversation: viewModel.contacts![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController()
        vc.viewModel = ChatViewModel(conversation: viewModel.contacts![indexPath.row], view: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
}
