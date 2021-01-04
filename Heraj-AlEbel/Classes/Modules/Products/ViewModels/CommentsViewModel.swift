//
//  CommentsViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol CommentsViewModelDelegate: class{
    func fetchCommentsDidSucceed()
    func fetchCommentsDidFailWithError(_ error: Error)
    func addCommentDidSucceed()
    func addCommentDidFailWithError(_ error: Error)
}

class CommentsViewModel{
    weak var view: CommentsViewModelDelegate?
    
    var product: Product!
    var comments: [Comment]?
    
    init(view: CommentsViewModelDelegate) {
        self.view = view
    }
    
    func fetchComments(){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.fetchComments(prodID: product.id), responseModel: [Comment].self){ [weak self] (result) in
            switch result{
            case .success(let comments):
                self?.comments = comments
                self?.view?.fetchCommentsDidSucceed()
            case .failure(let error):
                self?.view?.fetchCommentsDidFailWithError(error)
            }
        }
    }
    
    func addComment(comment: String){
        RequestManager.shared.performRequest(withRoute: ProductsEndPoint.addComment(prodID: product.id, comment: comment), responseModel: APIMessageResponse.self){ [weak self] (result) in
            switch result{
            case .success(let msg):
                UIHelper.showAlert(withMessage: msg.message)
                self?.view?.addCommentDidSucceed()
                self?.fetchComments()
            case .failure(let error):
                self?.view?.addCommentDidFailWithError(error)
            }
        }
    }
}
