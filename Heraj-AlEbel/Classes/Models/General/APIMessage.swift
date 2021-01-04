//
//  APIMessage.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 21/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import MessageKit

struct APIMessage: Codable{
    
    
    var id: Int!
    var parentID: Int!
    var senderID: Int!
    var receiverID: Int!
    var messageFromUser: User!
    var receiver: User!
    var message: String!
    var dateTime: String!
    
    enum CodingKeys: String, CodingKey{
        case id, message, dateTime
        case parentID = "parent_id"
        case messageFromUser = "message_from_user"
        case senderID = "message_from"
        case receiver = "message_to_user"
        case receiverID = "message_to"
        
    }
}

struct messageSa7: MessageType{
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    
}


/*{
 "id":(int),
 "parent_id":(int),
 "message_from":(int),
 "message_from_user":{object},
 "message_to":(int),
 "message_to_user":{object},
 "message":(string),
 "dateTime":(2019-01-22 05:27:18)
 } */
