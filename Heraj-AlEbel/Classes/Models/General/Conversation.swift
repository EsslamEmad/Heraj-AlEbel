//
//  Conversation.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 21/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Conversation: Codable{
    var currentUser: User!
    var otherUser: User!
    var messages: [APIMessage]!
    
    
    enum CodingKeys: String, CodingKey{
        case currentUser = "user"
        case otherUser = "other_user"
        case messages
    }
}



/*{
    "user":{user object},
    "other_user":{user object},
    "messages":[{messages object}]
}*/
