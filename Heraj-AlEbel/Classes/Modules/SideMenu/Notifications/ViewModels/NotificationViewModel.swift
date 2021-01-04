//
//  NotificationViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationsViewModelDelegate: class{
    func getNotificationsDidSucceed()
    func getNotificationsDidFailWithError(_ error: Error)
    func presentViewController(vc: UIViewController)
}

class NotificationsViewModel{
    
    weak var view: NotificationsViewModelDelegate?
    var notifications: [APINotification]?
    
    init(view: NotificationsViewModelDelegate) {
        self.view = view
    }
    
    func getNotifications(){
        RequestManager.shared.performRequest(withRoute: SideMenuEndPoint.getNotifications, responseModel: [APINotification].self){
            [weak self] (result) in
            switch result{
            case .success(let notifications):
                self?.notifications = notifications
                self?.view?.getNotificationsDidSucceed()
            case .failure(let error):
                self?.view?.getNotificationsDidFailWithError(error)
            }
        }
    }
    
    
    
     func presentProduct(forOrderID productID: Int) {
        UIHelper.showLoading()
        fetchProductByID(productID) { (product) in
            UIHelper.hideLoading()
            guard let product = product else { return }
            let vc = ProductViewController.nib()
            vc.viewModel = ProductViewModel(view: vc)
            vc.viewModel.product = product
            self.view?.presentViewController(vc: vc)
        }
        
    }
    
     func presentChat(forUserID userID: Int) {
        UIHelper.showLoading()
        fetchUserByID(userID) { (user) in
            UIHelper.hideLoading()
            guard let user = user else { return }
            let vc = ChatViewController()
            vc.viewModel = ChatViewModel(view: vc, otherUser: user)
            self.view?.presentViewController(vc: vc)
            
        }
    }
    
    func fetchProductByID(_ productID: Int, completion: @escaping (Product?) -> Void){
        RequestManager.shared.performRequest(withRoute: HomeEndPoint.getProduct(prodID: productID), responseModel: Product.self){(result) in
            switch result {
            case .success(let product):
                completion(product)
            case .failure(let error):
                UIHelper.showAlert(withMessage: error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func fetchUserByID(_ userID: Int, completion: @escaping (User?) -> Void){
        RequestManager.shared.performRequest(withRoute: HomeEndPoint.getUser(id: userID), responseModel: User.self){(result) in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                UIHelper.showAlert(withMessage: error.localizedDescription)
                completion(nil)
            }
        }
    }
}
