//
//  APINotification.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 21/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct APINotification: Codable{
    var id: Int!
    var userID: Int!
    var type: Int!
    var productID: Int!
    var title: String!
    var message: String!
    var date: String!
    
    enum CodingKeys: String, CodingKey{
        case id, title, type, message, date
        case userID = "user_id"
        case productID = "product_id"
    }
}




/*{
 "id":(int),
 "user_id":(int),
 "type":(int),
 "product_id":(int),
 "title":(string),
 "message":(string),
 "date":(string)
 }*/
