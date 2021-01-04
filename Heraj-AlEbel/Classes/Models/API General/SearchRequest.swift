//
//  SearchRequest.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct SearchRequest: Codable{
    var categoryID: Int!
    var cityID: Int!
    var order: Int!
    var searchWord: String!
    var clientID: Int!
    
    enum CodingKeys: String, CodingKey{
        case categoryID = "category_id"
        case cityID = "city_id"
        case order
        case searchWord = "search_word"
        case clientID = "client_id"
    }
}
