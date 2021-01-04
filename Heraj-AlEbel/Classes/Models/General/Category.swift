//
//  Category.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 21/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Category: Codable{
    var id: Int!
    var title: String!
    var parentID: Int?
    var isSelected: Bool? = false
    
    enum CodingKeys: String, CodingKey{
        case id, title
        case parentID = "parent_code"
        case isSelected
    }
}


/*{
 "id":(int),
 "title":(string),
 "parent_code":(int),
 } */
