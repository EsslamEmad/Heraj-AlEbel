//
//  CategoriesProvider.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 28/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

public enum CategoriesEndPoint {
    case getCategories
    
}

extension CategoriesEndPoint: EndpointType {
    
    var baseURL: URL {
        // TODO: Use constants for strings
        // TODO: Move to base provider
        let urlString = APIKeys.mainURL
        guard let url = URL(string: urlString) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getCategories:
            return "getCategory"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getCategories:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
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


