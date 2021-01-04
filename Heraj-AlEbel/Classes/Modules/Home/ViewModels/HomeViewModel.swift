//
//  HomeViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 23/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: class {
    func fetchDataDidSucceed()
    func fetchDataDidFailWithError(_ error: Error)
    func fetchRestaurantsDidSucceed()
       func fetchRestaurantsDidFailWithError(_ error: Error)
       func fetchCategoriesDidSucceed()
       func fetchCategoriesDidFailWithError(_ error: Error)
       func getBannersDidSucceed()
}

class HomeViewModel{
    weak var view: HomeViewModelDelegate?
    var data: HomeData?
    var Banners = [Banner]()
    var products: [Product]?

      var categories = [Category]()
    
    //Mark:- Initialization
    init(view: HomeViewModelDelegate) {
        self.view = view
        getBanners()
    }
    
    //Mark:- API Calls
    
    func fetchData(){
        RequestManager.shared.performRequest(withRoute: HomeEndPoint.getHomeData, responseModel: HomeData.self) { [weak self] (result) in
            switch result{
            case .success(let data):
                self?.data = data
                self?.view?.fetchDataDidSucceed()
            case .failure(let error):
                self?.view?.fetchDataDidFailWithError(error)
            }
        }
    }
    
    func fetchCategories() {
          RequestManager.shared.performRequest(withRoute: CategoriesEndPoint.getCategories, responseModel: [Category].self) { [weak self] (result) in
              switch result {
              case .success(let categories):
                  self?.categories = categories
                  self?.view?.fetchCategoriesDidSucceed()
              case .failure(let error):
                  self?.view?.fetchCategoriesDidFailWithError(error)
              }
          }
      }
      
      func fetchVenuesInCategory(_ category: Category?) {
         RequestManager.shared.performRequest(withRoute: ProductsEndPoint.getProducts(catID: category!.id), responseModel: [Product].self){ [weak self] (result) in
             switch result{
             case .success(let products):
                 self?.products = products
                 self?.view?.fetchRestaurantsDidSucceed()
             case .failure(let error):
                 self?.view?.fetchRestaurantsDidFailWithError(error)
             }
         }
      }
      
      // MARK: - Data manipulation
      func selectItemAtIndex(_ index: Int) {
          for (index, _) in categories.enumerated() {
              categories[index].isSelected = false
          }
          categories[index].isSelected = true
      }
      
      
      func getBanners(){
          RequestManager.shared.performRequest(withRoute: HomeEndPoint.banners, responseModel: [Banner].self){ [weak self] (result) in
              switch result{
              case .success(let banners):
                  self?.Banners = banners
                  self?.view?.getBannersDidSucceed()
              case .failure(let error):
                  self?.view?.fetchCategoriesDidFailWithError(error)
              }
          }
      }
}
