//
//  ProductViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 2/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol ProductViewModelDelegate: class {
    func fetchProductDidSucceed()
    func fetchProductDidFailWithError(_ error: Error)
    func fetchRelatedDidSucceed()
    func fetchRelatedDidFailWithError(_ error: Error)
    func favoriteStateDidChangeWithState(_ state: Bool)
    func favoriteStateDidFailWithError(_ error: Error)
    func reportProductDidSucceed()
    func reportProductDidFailWithError(_ error: Error)
    
}


class ProductViewModel{
    
    var product: Product!
    var relatedProducts: [Product]?
    weak var view: ProductViewModelDelegate?
    
    init(view: ProductViewModelDelegate) {
        self.view = view
    }
    
    func fetchProduct(){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.fetchProduct(prodID: product.id), responseModel: Product.self) { [weak self] (result) in
            switch result{
            case .success(let product):
                self?.product = product
                self?.view?.fetchProductDidSucceed()
            case .failure(let error):
                self?.view?.fetchProductDidFailWithError(error)
            }
        }
    }
    
    func fetchRelatedProducts(){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.fetchRelatedProducts(prodID: product.id), responseModel: [Product].self){ [weak self] (result) in
            switch result{
            case .success(let products):
                self?.relatedProducts = products
                self?.view?.fetchRelatedDidSucceed()
            case .failure(let error):
                self?.view?.fetchRelatedDidFailWithError(error)
            }
        }
    }
    
    func favoriteProduct(){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.favoriteProduct(prodID: product.id, state: !product.isFavorite), responseModel: APIMessageResponse.self){ [weak self] (result) in
            switch result{
            case .success(let resp):
                self?.view?.favoriteStateDidChangeWithState(true)
                UIHelper.showAlert(withMessage: resp.message)
            case .failure(let error):
                self?.view?.favoriteStateDidFailWithError(error)
            }
        }
    }
    
    func getReportReasons(){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.getReportReasons, responseModel: [APIReport].self) { [weak self] (result) in
            
        }
    }
    
    func reportProduct(reasonID: Int){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.reportProduct(prodID: product.id, reasonID: reasonID), responseModel: APIMessageResponse.self){ [weak self] (result) in
            switch result{
            case .success(let resp):
                self?.view?.reportProductDidSucceed()
                UIHelper.showAlert(withMessage: resp.message)
            case .failure(let error):
                self?.view?.reportProductDidFailWithError(error)
            }
        }
    }
    
}
