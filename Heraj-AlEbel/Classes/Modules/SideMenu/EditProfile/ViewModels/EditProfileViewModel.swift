//
//  EditProfileViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Firebase

protocol EditProfileViewModelDelegate: class {
    func editDidSucceed()
    func editDidFailWithError(_ error: Error)
}

class EditProfileViewModel {
    
    // MARK: - Variables
    weak var view: EditProfileViewModelDelegate?
    
    // MARK: - Intialization
    init(view: EditProfileViewModelDelegate) {
        self.view = view
    }
    
    // MARK: - API calls
    
    func upload(user: User, image: UIImage?){
        var thisUser = user
        if image != nil{
            RequestManager.shared.performRequest(withRoute: HomeEndPoint.upload(photo: image!), responseModel: APIPhoto.self){ [weak self] (result) in
                switch result {
                case .success(let img):
                    thisUser.photo = img.image
                    self?.editUser(user: thisUser)
                case .failure(let error):
                    self?.view?.editDidFailWithError(error)
                }
            }
            
        }else {
            editUser(user: thisUser)
        }
    }
    
    func editUser(user: User) {
        RequestManager.shared.performRequest(withRoute: SideMenuEndPoint.editUser(user: user), responseModel: User.self) { [weak self] (result) in
            switch result {
            case .success(let user):
                Defaults[.user] = user
                self?.view?.editDidSucceed()
            case .failure(let error):
                self?.view?.editDidFailWithError(error)
            }
        }
    }
}
