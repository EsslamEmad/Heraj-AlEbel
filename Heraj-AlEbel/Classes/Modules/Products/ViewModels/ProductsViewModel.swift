//
//  ProductsViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 1/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol ProductsViewModelDelegate: class {
    func fetchProductsDidSucceed()
    func fetchProductsDidFailWithError(_ error: Error)
}

class ProductsViewModel{
    
    weak var view: ProductsViewModelDelegate?
    var category: Category?
    var products: [Product]?
    var userID: Int?
    var searchRequest: SearchRequest?
    
    init(view: ProductsViewModelDelegate) {
        self.view = view
    }
    
    
    func fetchProducts(){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.getProducts(catID: category!.id), responseModel: [Product].self){ [weak self] (result) in
            switch result{
            case .success(let products):
                self?.products = products
                self?.view?.fetchProductsDidSucceed()
            case .failure(let error):
                self?.view?.fetchProductsDidFailWithError(error)
            }
        }
    }
    
    func fetchProductsForUser(){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.fetchProductsForUser(userID: userID!), responseModel: [Product].self){ [weak self] (result) in
            switch result{
            case .success(let products):
                self?.products = products
                self?.view?.fetchProductsDidSucceed()
            case .failure(let error):
                self?.view?.fetchProductsDidFailWithError(error)
            }
        }
    }
    
    func search(){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.search(searchRequest: searchRequest!), responseModel: [Product].self){ [weak self] (result) in
            switch result{
            case .success(let products):
                self?.products = products
                self?.view?.fetchProductsDidSucceed()
            case .failure(let error):
                self?.view?.fetchProductsDidFailWithError(error)
            }
        }
    }
}
