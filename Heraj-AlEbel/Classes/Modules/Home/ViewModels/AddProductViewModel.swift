//
//  AddProductViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import UIKit

protocol AddProductViewModelDelegate: class{
    func addProductDidSucceed()
    func addProductDidFailWithError(_ error: Error)
    func getCatsDidSucceed()
    func getCatsDidFailWithError(_ error: Error)
    func getCitiesDidSucceed()
    func getCitiesDidFailWithError(_ error: Error)
    func editProductDidSucceed()
}

class AddProductViewModel{
    
    weak var view: AddProductViewModelDelegate?
    
    var photos = [String]()
    var AllCategories: [Category]?
    var categories: [Category]?
    var cities: [City]?
    var product: Product!
    var subCategories: [Category]?
    
    init(view: AddProductViewModelDelegate) {
        self.view = view
    }
    
    func addProduct(product: Product, images: [UIImage]){
        self.product = product
        uploadImages(at: 0, images: images)
    }
    
    
    private func uploadImages(at Index: Int, images: [UIImage]){
        RequestManager.shared.performRequest(withRoute: HomeEndPoint.upload(photo: images[Index]), responseModel: APIPhoto.self){ [weak self] (result) in
            
            switch result{
            case .success(let photo):
                self?.photos.append(photo.image)
                if Index == images.count - 1{
                    self?.addProductRequest()
                }else {
                    self?.uploadImages(at: Index + 1, images: images)
                }
            case .failure(let error):
                self?.view?.addProductDidFailWithError(error)
            }
        }
    }
    private func addProductRequest(){
        RequestManager.shared.performRequest(withRoute: HomeEndPoint.addProduct(product: product, photos: photos), responseModel: APIMessageResponse.self) { [weak self] (result) in
            switch result {
            case .success(let resp):
                //UIHelper.showAlert(withMessage: resp.message)
                self?.view?.addProductDidSucceed()
            case .failure(let error):
                self?.view?.addProductDidFailWithError(error)
            }
        }
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
    
    func editProduct(product: Product, images: [UIImage]?){
        self.product = product
        if images == nil{
            editProductRequest(photos: nil)
        }else {
            uploadImagesForEdit(at: 0 , images: images!)
        }
    }
    
    func uploadImagesForEdit(at Index: Int, images: [UIImage]){
        
        RequestManager.shared.performRequest(withRoute: HomeEndPoint.upload(photo: images[Index]), responseModel: APIPhoto.self){ [weak self] (result) in
            
            switch result{
            case .success(let photo):
                self?.photos.append(photo.image)
                if Index == images.count - 1{
                    self?.editProductRequest(photos: self?.photos)
                }else {
                    self?.uploadImages(at: Index + 1, images: images)
                }
            case .failure(let error):
                self?.view?.addProductDidFailWithError(error)
            }
        }
    }
    
    
    func editProductRequest(photos: [String]?){
        RequestManager.shared.performRequest(withRoute: HomeEndPoint.editProduct(product: product, photos: photos), responseModel: [Product].self) { [weak self] (result) in
            switch result {
            case .success(_):
                //UIHelper.showAlert(withMessage: "تم تعديل المنتج بنجاح")
                self?.view?.editProductDidSucceed()
            case .failure(let error):
                self?.view?.addProductDidFailWithError(error)
            }
        }
    }
}
