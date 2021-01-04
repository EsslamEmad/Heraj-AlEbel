//
//  ChatResponse.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct ChatResponse: Codable {
    var item: [APIMessage]
    var items: [Conversation]
    var otherUser: User!
    
    enum CodingKeys: String, CodingKey{
        case item, items
        case otherUser = "other_user"
    }
}
