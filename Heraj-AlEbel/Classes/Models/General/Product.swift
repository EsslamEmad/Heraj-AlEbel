//
//  Product.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 21/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Product: Codable{
    var id: Int!
    var title: String!
    var details: String!
    var price: Double?
    var userID: Int!
    var user: User!
    var categoryID: Int!
    var category: Category!
    var phone: String!
    var showPhone: Bool!
    var referenceNumber: Int!
    var cityID: Int!
    var city: City!
    var isActive: Int!
    var isFavorite: Bool!
    var comment: Bool!
    var photos: [APIPhoto]!
    
    enum CodingKeys: String, CodingKey{
        case id, title, details, price, user, category, phone, city, comment, photos, isFavorite
        case userID = "user_id"
        case categoryID = "category_id"
        case showPhone = "show_phone"
        case referenceNumber = "reference_number"
        case cityID = "city_id"
        case isActive = "active"
        
    }
}

/*{
 id: (int),
 title: (string),
 details: (string),
 price: (float),
 user_id:(int),
 user:(object user),
 category_id:(int),
 category:(object category),
 phone:(string),
 show_phone:(int)[0:yes;1:no;],
 reference_number:(int),
 city_id:(int),
 city:(object city),
 active:(int)[0:active,1:not],
 isFavorite:(bool),
 comment:(bool),
 photos: [
 {
 image: (string),
 thumb: (url)
 }
 ]
 }*/
