//
//  MyAdsViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol MyAdsViewModelDelegate:class{
    func removeDidSucceed()
    func removeDidFailWithError(_ error: Error)
    func getMyAdsDidSucceed()
    func getMyAdsDidFailWithError(_ error: Error)
}

class MyAdsViewModel{
    
    var myAds: [Product]?
    
    weak var view: MyAdsViewModelDelegate?
    
    init(view: MyAdsViewModelDelegate) {
        self.view = view
    }
    
    func getMyAds(){
        RequestManager.shared.performRequest(withRoute: SideMenuEndPoint.getMyAds, responseModel: [Product].self){
            [weak self] (result) in
            switch result{
            case .success(let products):
                self?.myAds = products
                self?.view?.getMyAdsDidSucceed()
            case .failure(let error):
                self?.view?.getMyAdsDidFailWithError(error)
            }
        }
    }
    
    func remove(product: Product){
        RequestManager.shared.performRequest(withRoute: SideMenuEndPoint.removeProduct(prodID: product.id), responseModel: [Product].self) { [weak self] (result) in
            switch result {
            case .success(let products):
                self?.myAds = products
                self?.view?.removeDidSucceed()
            case .failure(let error):
                self?.view?.removeDidFailWithError(error)
            }
        }
    }
}
