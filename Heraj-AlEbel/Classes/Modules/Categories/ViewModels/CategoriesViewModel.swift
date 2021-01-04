//
//  CategoriesViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 28/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol CategoriesViewModelDelegate: class{
    func fetchCategoriesDidSucceed()
    func fetchCategoriesDidFailWithError(_ error: Error)
}

class CategoriesViewModel{
    
    weak var view: CategoriesViewModelDelegate?
    var parentID: Int!
    var categories: [Category]?
    var filteredCategories = [Category]()
    
    init(view: CategoriesViewModelDelegate) {
        self.view = view
    }
    
    //MARK: API Calls
    func fetchCategories(){
        RequestManager.shared.performRequest(withRoute: CategoriesEndPoint.getCategories, responseModel: [Category].self){ [weak self] (result) in
            switch result{
            case .success(let categories):
                self?.categories = categories
                self?.filterCategories()
                self?.view?.fetchCategoriesDidSucceed()
            case .failure(let error):
                self?.view?.fetchCategoriesDidFailWithError(error)
            }
        }
    }
    
    func filterCategories(){
        for category in categories!{
            if category.parentID! == parentID{
                filteredCategories.append(category)
            }
        }
        
    }
}
