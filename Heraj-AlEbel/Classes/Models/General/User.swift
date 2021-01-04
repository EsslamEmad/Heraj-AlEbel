//
//  User.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 21/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import MessageKit
import SwiftyUserDefaults

struct User: Codable, DefaultsSerializable{
    var id: Int!
    var name: String!
    var phone: String!
   // var email: String!
    var status: Int!
    var photo: String?
    var token: String?
    var password: String?
    var firstLogin: String?
}

extension User: SenderType {
    
    var senderId: String {
        return String(id)
    }
    
    var displayName: String {
        return name ?? ""
    }
    
}

/*{
 id: (int),
 name: (string),
 phone: (string),
 email: (string),
 photo: (url),
 status:(int),
 token: (string),
 }*/
