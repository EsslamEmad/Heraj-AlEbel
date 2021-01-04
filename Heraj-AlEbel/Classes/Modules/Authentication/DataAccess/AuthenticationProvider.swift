//
//  AuthenticationProvider.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 23/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

public enum AuthenticationEndpoint {
    case login(name: String, phone: String, password: String, token: String?)
    case register(name: String, phoneNumber: String, password: String, token: String?)
    case forgotPassword(email: String)
    
}

extension AuthenticationEndpoint: EndpointType {
    
    var baseURL: URL {
        // TODO: Use constants for strings
        // TODO: Move to base provider
        let urlString = APIKeys.mainURL
        guard let url = URL(string: urlString) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register"
        case .forgotPassword:
            return "forgotPassword"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login, .register, .forgotPassword:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .login(name: let name, phone: let phone, password: let password, token: let token):
            // TODO: Use constants for keys
            return .requestParameters(bodyParameters: ["name": name, "phone": phone, "password": password, "token": token as Any], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .register(name: let name, phoneNumber: let phoneNumber, password: let password, token: let token):
            // TODO: Use constants for keys
            return .requestParameters(bodyParameters: ["phone": phoneNumber, "password": password, "name": name, "token": token as Any], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .forgotPassword(email: let email):
            return .requestParameters(bodyParameters: ["email": email], bodyEncoding: .jsonEncoding, urlParameters: nil)
        default:
            return .requestPlain
        }
    }
    
    var headers: HTTPHeaders? {
        // TODO: Move to base provider
        return ["client": APIKeys.clientKey,
                "secret": APIKeys.secretKey]
    }
}
