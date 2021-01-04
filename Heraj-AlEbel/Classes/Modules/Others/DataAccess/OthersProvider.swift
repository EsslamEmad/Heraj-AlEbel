//
//  OthersProvider.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

public enum OthersEndPoint {
    case contactUs(message: String, title: String, phone: String, email: String, address: String)
    case aboutUs
    case getSettings
    
}

extension OthersEndPoint: EndpointType {
    
    var baseURL: URL {
        // TODO: Use constants for strings
        // TODO: Move to base provider
        let urlString = APIKeys.mainURL
        guard let url = URL(string: urlString) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .aboutUs:
            return "pages/1"
        case .contactUs:
            return "contactUs"
        case .getSettings:
            return "getSettings"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .aboutUs, .getSettings:
            return .get
        default: return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .contactUs(message: let msg, title: let title, phone: let phone, email: let email, address: let address):
            return .requestParameters(bodyParameters: ["message": msg, "subject": title, "phone": phone, "email": email, "country": address], bodyEncoding: .jsonEncoding, urlParameters: nil)
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


