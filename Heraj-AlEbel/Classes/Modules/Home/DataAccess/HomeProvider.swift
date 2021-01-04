//
//  HomeProvider.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 23/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

 enum HomeEndPoint {
    case getHomeData
    case getCities
    case addProduct(product: Product, photos: [String])
    case upload(photo: UIImage)
    case editProduct(product: Product, photos: [String]?)
    case getProduct(prodID: Int)
    case getUser(id: Int)
    case banners
}

extension HomeEndPoint: EndpointType {
    
    var baseURL: URL {
        // TODO: Use constants for strings
        // TODO: Move to base provider
        let urlString = APIKeys.mainURL
        guard let url = URL(string: urlString) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getHomeData:
            return "homeScreen/\((Defaults[.user] == nil ? "" : String(Defaults[.user]!.id)))"
        case .getCities:
            return "cities"
        case .addProduct:
            return "addProduct"
        case .upload:
            return "upload"
        case .editProduct:
            return "editProduct"
        case .getProduct(prodID: let id):
            return "getProduct/\(id)/\((Defaults[.user] == nil ? "" : String(Defaults[.user]!.id)))"
        case .getUser(id: let id):
            return "getUser/\(id)"
        case .banners:
            return "getBanners"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getHomeData, .getCities, .getProduct, .getUser, .banners:
            return .get
        default: return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .addProduct(product: let p, photos: let photos):
            return .requestParameters(bodyParameters: ["user_id": Defaults[.user]!.id, "title": p.title, "details": p.details, "price": p.price, "category_id": p.isActive,  "phone": Defaults[.user]!.phone, "show_phone": p.showPhone, "city": p.cityID, "photos": photos], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .upload(photo: let photo):
            let data = photo.jpegData(compressionQuality: 0.1)!
            return .uploadMultipart(data: data, fileName: "image.jpeg")
        case .editProduct(product: let p, photos: let photos):
            if let ph = photos{
                return .requestParameters(bodyParameters: ["product_id": p.id, "user_id": Defaults[.user]!.id, "title": p.title, "details": p.details, "price": p.price, "category_id": p.isActive,  "phone": Defaults[.user]!.phone, "show_phone": p.showPhone, "city": p.cityID, "photos": ph], bodyEncoding: .jsonEncoding, urlParameters: nil)
            }else {
                return .requestParameters(bodyParameters: ["product_id": p.id, "user_id": Defaults[.user]!.id, "title": p.title, "details": p.details, "price": p.price, "category_id": p.isActive, "phone": Defaults[.user]!.phone, "show_phone": p.showPhone, "city": p.cityID], bodyEncoding: .jsonEncoding, urlParameters: nil)
            }
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
