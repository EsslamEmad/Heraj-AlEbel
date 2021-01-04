//
//  NotificationsViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: NotificationsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureUI()
        fetchNotifications()
    }
    

    func configureViewModel() {
        viewModel = NotificationsViewModel(view: self)
    }
    
    func configureUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NotificationTableViewCell.className, bundle: nil), forCellReuseIdentifier: NotificationTableViewCell.className)
        self.title = "الإشعارات"
    }
    
    func fetchNotifications(){
        UIHelper.showLoading()
        viewModel.getNotifications()
    }

}

extension NotificationsViewController: NotificationsViewModelDelegate{
    func presentViewController(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getNotificationsDidSucceed() {
        UIHelper.hideLoading()
        tableView.reloadData()
    }
    func getNotificationsDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.className) as! NotificationTableViewCell
        cell.titleLabel.text = viewModel.notifications![indexPath.row].message
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.notifications![indexPath.row].type.rawValue{
        case 1:
            viewModel.presentProduct(forOrderID: viewModel.notifications![indexPath.row].productID)
        case 2:
            viewModel.presentChat(forUserID: viewModel.notifications![indexPath.row].id)
        default: return
        }
    }
}
