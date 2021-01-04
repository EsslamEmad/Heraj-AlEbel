//
//  ChatViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import Kingfisher

protocol ChatViewModelDelegate: class {
    func addMessageDidSucceedWithMessage()
    func addMessageDidFailWithError(_ error: Error)
   
}

class ChatViewModel {
    
    // MARK: - Variables
    var conversation: Conversation!
    private let view: ChatViewModelDelegate
    var otherUser: User?
    var messages = [APIMessage]()
    
    // MARK: - Intialization
    init(conversation: Conversation, view: ChatViewModelDelegate) {
        self.conversation = conversation
        self.view = view
        messages = conversation.messages
        self.view.addMessageDidSucceedWithMessage()
    }
    
    
    init(view: ChatViewModelDelegate, otherUser: User) {
        self.view = view
        self.otherUser = otherUser
        conversation = Conversation()
        self.conversation.otherUser = otherUser
        fetchMessages()
    }
    
    func fetchMessages(){
        RequestManager.shared.performRequest(withRoute: SideMenuEndPoint.getConversation(userID: otherUser!.id), responseModel: ChatResponse.self){ [weak self] (result) in
            switch result {
            case .success(let conv):
                self?.conversation.messages = conv.item
                self?.conversation.otherUser = conv.otherUser
                self?.messages = conv.item
                
                self?.view.addMessageDidSucceedWithMessage()
            case .failure(let error):
                self?.view.addMessageDidFailWithError(error)
            }
        }
    }
    
    
    func sendMessage(message: String){
        RequestManager.shared.performRequest(withRoute: SideMenuEndPoint.sendMessage(userID: conversation.otherUser.id, message: message), responseModel: ChatResponse.self){ [weak self] (result) in
            switch result {
            case .success(let resp):
                self?.conversation = resp.items[0]
                self?.messages = self?.conversation.messages ?? [APIMessage]()
                self?.view.addMessageDidSucceedWithMessage()
            case .failure(let error):
                self?.view.addMessageDidFailWithError(error)
            }
        }
    }
    
}
