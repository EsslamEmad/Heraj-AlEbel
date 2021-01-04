//
//  ContactsViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol ContactsViewModelDelegate: class{
    func getContactsDidSucceed()
    func getContactsDidFailWithError(_ error: Error)
}

class ContactsViewModel{
    
    weak var view: ContactsViewModelDelegate?
    var contacts: [Conversation]?
    
    init(view: ContactsViewModelDelegate) {
        self.view = view
    }
    
    func getContacts(){
        RequestManager.shared.performRequest(withRoute: SideMenuEndPoint.getContacts, responseModel: [Conversation].self){
            [weak self] (result) in
            switch result {
            case .success(let contacts):
                self?.contacts = contacts
                self?.view?.getContactsDidSucceed()
            case .failure(let error):
                self?.view?.getContactsDidFailWithError(error)
            }
        }
    }
}
