//
//  HomeData.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 28/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

struct HomeData: Codable{
    var latestProducts: [Product]?
    var banner: String?
    var news: [APINews]?
    var general: [Product]?
    var mazayen: [Product]?
    var hagn: [Product]?
    var zabh: [Product]?
    var other: [Product]?
    
    enum CodingKeys: String, CodingKey{
        case banner, news, general, mazayen, hagn, zabh, other
        case latestProducts = "latest_products"
    }
}




