//
//  RegisterViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 23/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Firebase

protocol RegisterationViewModelDelegate: class {
    func registerationDidSucceed()
    func registerationDidFailWithError(_ error: Error)
}

class RegisterationViewModel {
    
    // MARK: - Variables
    weak var view: RegisterationViewModelDelegate?
    
    // MARK: - Intialization
    init(view: RegisterationViewModelDelegate) {
        self.view = view
    }
    
    // MARK: - API calls
    
    
    func registerUser(name: String, phone: String, password: String) {
        RequestManager.shared.performRequest(withRoute: AuthenticationEndpoint.register(name: name, phoneNumber: phone, password: password, token: Messaging.messaging().fcmToken), responseModel: User.self) { [weak self] (result) in
            switch result {
            case .success(let user):
                Defaults[.user] = user
                self?.view?.registerationDidSucceed()
            case .failure(let error):
                self?.view?.registerationDidFailWithError(error)
            }
        }
    }
}
