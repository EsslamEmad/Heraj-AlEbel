//
//  ProductsProvider.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 1/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

 enum ProductsEndPoint {
    case getProducts(catID: Int)
    case fetchProduct(prodID: Int)
    case fetchRelatedProducts(prodID: Int)
    case favoriteProduct(prodID: Int, state: Bool)
    case reportProduct(prodID: Int, reasonID: Int)
    case getReportReasons
    case fetchProductsForUser(userID: Int)
    case fetchComments(prodID: Int)
    case addComment(prodID: Int, comment: String)
    case search(searchRequest: SearchRequest)
}

extension ProductsEndPoint: EndpointType {
    
    var baseURL: URL {
        // TODO: Use constants for strings
        // TODO: Move to base provider
        let urlString = APIKeys.mainURL
        guard let url = URL(string: urlString) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getProducts(catID: let id):
            return "getProductsByCatId/\(id)/\((Defaults[.user] == nil ? "" : String(Defaults[.user]!.id)))"
        case .fetchProduct(prodID: let id):
            return "getProduct/\(id)/\((Defaults[.user] == nil ? "" : String(Defaults[.user]!.id)))"
        case .fetchRelatedProducts(prodID: let id):
            return "relatedProducts/\(id)/\((Defaults[.user] == nil ? "" : String(Defaults[.user]!.id)))"
        case .favoriteProduct(prodID: _, state: let state):
            if state{
                return "addToWhishlist"
            }else {
                return "deleteWhishlist"
            }
        case .reportProduct:
            return "addReporting"
        case .getReportReasons:
            return "getReasonsReporting"
            
        case .fetchProductsForUser(userID: let id):
            return "getProductsByUserId/\(id)/\((Defaults[.user] == nil ? "" : String(Defaults[.user]!.id)))"
        case .fetchComments:
            return "getComments"
        case .addComment:
            return "addComment"
        case .search:
            return "search"
        }
        
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getProducts, .fetchProduct, .fetchRelatedProducts, .getReportReasons, .fetchComments :
            return .get
        default:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .favoriteProduct(prodID: let id, state: _):
            return .requestParameters(bodyParameters: ["product_id": id, "client_id": Defaults[.user]!.id], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .reportProduct(prodID: let prodID, reasonID: let resID):
            return .requestParameters(bodyParameters: ["product_id": prodID, "user_id": (Defaults[.user]!.id)!, "reason_id": resID], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .fetchComments(prodID: let id):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["product_id": id as Any])
        case .addComment(prodID: let id, comment: let comment):
            return .requestParameters(bodyParameters: ["user_id": Defaults[.user]!.id, "product_id": id, "comment": comment], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .search(searchRequest: let sr):
            return .requestParameters(bodyParameters: ["category_id": sr.categoryID, "city_id": sr.cityID, "order": sr.order, "search_word": sr.searchWord, "client_id": sr.clientID], bodyEncoding: .jsonEncoding, urlParameters: nil)
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


