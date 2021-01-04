//
//  SideMenuProdvide.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum SideMenuEndPoint {
    case getFavorite
    case removeFavorite(prodID: Int)
    case getMyAds
    case removeProduct(prodID: Int)
    case editUser(user: User)
    case getNotifications
    case getContacts
    case getConversation(userID: Int)
    case sendMessage(userID: Int, message: String)
}

extension SideMenuEndPoint: EndpointType {
    
    var baseURL: URL {
        // TODO: Use constants for strings
        // TODO: Move to base provider
        let urlString = APIKeys.mainURL
        guard let url = URL(string: urlString) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getFavorite:
            return "getWhishlist/\((Defaults[.user]!.id)!)"
        case .removeFavorite:
            return "deleteWhishlist"
        case .getMyAds:
            return "getProductsByUserId/\((Defaults[.user] == nil ? "" : String(Defaults[.user]!.id)))"
        case .removeProduct:
            return"deleteProduct"
        case .editUser:
            return "editUser"
        case .getNotifications:
            return "notifications/\((Defaults[.user] == nil ? "" : String(Defaults[.user]!.id)))"
        case .getContacts:
            return "getMessagesForUser/\((Defaults[.user] == nil ? "" : String(Defaults[.user]!.id)))"
        case .getConversation(userID: let id):
            return "getChatBetweenTwoUsers/\((Defaults[.user] == nil ? "" : String(Defaults[.user]!.id)))/\(id)"
        case .sendMessage:
            return "addMessage"
        
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getFavorite, .getMyAds, .getNotifications, .getContacts, .getConversation:
            return .get
        default: return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .removeFavorite(prodID: let id):
            return .requestParameters(bodyParameters: ["client_id": (Defaults[.user]!.id)!, "product_id": id], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .removeProduct(prodID: let id):
            return .requestParameters(bodyParameters: ["user_id": (Defaults[.user]!.id)!, "product_id": id], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .editUser(user: let user):
            return .requestParameters(bodyParameters: ["user_id": user.id, "name": user.name, "phone": user.phone, "password": user.password, "photo": user.photo], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .sendMessage(userID: let id, message: let msg):
            return .requestParameters(bodyParameters: ["message_from": (Defaults[.user]!.id)!, "message_to": id, "message": msg], bodyEncoding: .jsonEncoding, urlParameters: nil)
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
