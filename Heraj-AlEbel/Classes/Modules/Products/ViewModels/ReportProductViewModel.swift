//
//  ReportProductViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 6/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol ReportProductViewModelDelegate: class{
    func getReasonsDidSucceed()
    func getReasonsDidFailWithError(_ error: Error)
    func reportDidSucceed(_ message: String)
    func reportDidFailWithError(_ error: Error)
}


class ReportProductViewModel{
    
    weak var view: ReportProductViewModelDelegate?
    var product: Product!
    var resaons: [APIReport]?
    
    init(view: ReportProductViewModelDelegate, product: Product) {
        self.view = view
        self.product = product
    }
    
    func getReasons(){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.getReportReasons, responseModel: [APIReport].self) { [weak self] (result) in
            switch result {
            case .success(let reasons):
                self?.resaons = reasons
                self?.view?.getReasonsDidSucceed()
            case .failure(let error):
                self?.view?.getReasonsDidFailWithError(error)
            }
        }
    }
    
    func reportProduct(reasonID: Int){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.reportProduct(prodID: product.id, reasonID: reasonID), responseModel: APIMessage.self){
            [weak self] (result) in
            switch result{
            case .success(let msg):
                self?.view?.reportDidSucceed(msg.message)
            case .failure(let error):
                self?.view?.reportDidFailWithError(error)
            }
        }
    }
}
