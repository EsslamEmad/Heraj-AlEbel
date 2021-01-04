//
//  APINotification.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 19/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import Foundation

enum APINotificationType: Int, Codable {
    case orderPendingApproval = 1
    case orderApproved = 2
    case orderAssignedToRep = 3
    case orderDelivered = 4
    case orderRejected = 5
    case rateMeal = 6
    case sendReceipt = 7
    case paymentMethod = 8
    case rechargeBalance = 9
    case discountBalance = 10
    case updateBalance = 11
    case rateUser = 12
    case orderConfirmedAndRepAccepted = 13
    case newMessage = 14
}

struct APINotification: Codable{
    var id: Int!
    var userID: Int!
    var type: APINotificationType!
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
