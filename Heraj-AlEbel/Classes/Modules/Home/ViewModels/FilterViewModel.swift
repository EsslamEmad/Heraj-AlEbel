//
//  FilterViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol FilterViewModelDelegate: class {
    func getCatsDidSucceed()
    func getCatsDidFailWithError(_ error: Error)
    func getCitiesDidSucceed()
    func getCitiesDidFailWithError(_ error: Error)
}

class FilterViewModel{
    
    weak var view: FilterViewModelDelegate?
    var searchRequest = SearchRequest()
    var AllCategories: [Category]?
    var categories: [Category]?
    var cities: [City]?
    var subCategories: [Category]?
    init(view: FilterViewModelDelegate) {
        self.view = view
    }
    
    func getCitites(){
        RequestManager.shared.performRequest(withRoute: HomeEndPoint.getCities, responseModel: [City].self) { [weak self] (result) in
            switch result{
            case .success(let cities):
                self?.cities = cities
                self?.view?.getCitiesDidSucceed()
            case .failure(let error):
                self?.view?.getCitiesDidFailWithError(error)
            }
        }
    }
    
    func getCategories(){
        RequestManager.shared.performRequest(withRoute: CategoriesEndPoint.getCategories, responseModel: [Category].self) { [weak self] (result) in
            switch result{
            case .success(let categories):
                self?.AllCategories = categories
                self?.filterCats()
                self?.view?.getCatsDidSucceed()
            case .failure(let error):
                self?.view?.getCatsDidFailWithError(error)
            }
        }
    }
    
    private func filterCats(){
        categories = AllCategories
        categories?.removeAll(where: {$0.parentID != 0})
    }
    
    func filterSubCats(id: Int){
        subCategories = AllCategories?.filter({$0.parentID == id})
    }
    
}
