//
//  FavoritesViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol FavoritesViewModelDelegate:class{
    func removeFromFavoritesDidSucceed()
    func removeFromFavoritesDidFailWithError(_ error: Error)
    func getFavoritesDidSucceed()
    func getFavoritesDidFailWithError(_ error: Error)
}

class FavoritesViewModel{
    
    var favorites: [Product]?
    
    weak var view: FavoritesViewModelDelegate?
    
    init(view: FavoritesViewModelDelegate) {
        self.view = view
    }
    
    func getFavorites(){
        RequestManager.shared.performRequest(withRoute: SideMenuEndPoint.getFavorite, responseModel: [Product].self){
            [weak self] (result) in
            switch result{
            case .success(let products):
                self?.favorites = products
                self?.view?.getFavoritesDidSucceed()
            case .failure(let error):
                self?.view?.getFavoritesDidFailWithError(error)
            }
        }
    }
    
    func removeFromFavorite(product: Product){
        RequestManager.shared.performRequest(withRoute: SideMenuEndPoint.removeFavorite(prodID: product.id), responseModel: [Product].self) { [weak self] (result) in
            switch result {
            case .success(let products):
                self?.favorites = products
                self?.view?.removeFromFavoritesDidSucceed()
            case .failure(let error):
                self?.view?.removeFromFavoritesDidFailWithError(error)
            }
        }
    }
}
