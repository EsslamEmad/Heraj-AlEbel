//
//  LoginViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 23/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import SwiftyUserDefaults
import Firebase

protocol LoginViewModelDelegate: class {
    func userAuthenticationDidSucceed()
    func userAuthenticationDidFailWithError(_ error: Error)
    func forgotPasswordDidSucceedWithMessage(_ message: String)
    func forgotPasswordDidFailWithError(_ error: Error)
}

class LoginViewModel {
    
    // MARK: - Variables
    weak var view: LoginViewModelDelegate?
    
    // MARK: - Intialization
    init(view: LoginViewModelDelegate) {
        self.view = view
    }
    
    // MARK: - API calls
    func authenticateUser(name: String, phone: String, password: String) {
        RequestManager.shared.performRequest(withRoute: AuthenticationEndpoint.login(name: name, phone: phone, password: password, token: Messaging.messaging().fcmToken), responseModel: User.self) { [weak self] (result) in
            switch result {
            case .success(let user):
                Defaults[.user] = user
                self?.view?.userAuthenticationDidSucceed()
            case .failure(let error):
                self?.view?.userAuthenticationDidFailWithError(error)
            }
        }
    }
    
    func forgotPassword(email: String){
        RequestManager.shared.performRequest(withRoute: AuthenticationEndpoint.forgotPassword(email: email), responseModel: APIMessageResponse.self){ [weak self] (result) in
            switch result{
            case .success(let resp):
                self?.view?.forgotPasswordDidSucceedWithMessage(resp.message!)
            case .failure(let error):
                self?.view?.forgotPasswordDidFailWithError(error)
            }
        }
    }
    
}

