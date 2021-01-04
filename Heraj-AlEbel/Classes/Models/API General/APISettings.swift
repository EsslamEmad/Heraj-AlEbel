//
//  APISettings.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 17/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
struct APISettings: Codable{
    var phone: String!
    var email: String!
    var facebook: String!
    var instagram: String!
    var twitter:  String!
    var bankDetails: String!
    
    enum CodingKeys: String, CodingKey{
        case phone = "phone1"
        case email = "admin_email"
        case facebook, twitter
        case instagram = "insta"
        case bankDetails = "bank_transfer"
    }
}
