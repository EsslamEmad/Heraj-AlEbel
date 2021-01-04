//
//  CommentsViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class CommentsViewController: UIViewController {

    
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var addCommentButton: UIButton!
    
    var viewModel: CommentsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchData()
        
    }
    
    func fetchData(){
        UIHelper.showLoading()
        viewModel.fetchComments()
    }

    func configureUI(){
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.register(UINib(nibName: CommentTableViewCell.className, bundle: nil), forCellReuseIdentifier: CommentTableViewCell.className)
        if Defaults[.user] == nil {
            addCommentButton.alpha = 0
            commentTextView.alpha = 0
        }
        
    }
    
    @IBAction func didPressAddComment(_ sender: UIButton){
        guard let comment = commentTextView.text, comment != "" else {
            UIHelper.showAlert(withMessage: "من فضلك قم بإدخال تعليقك")
            return
        }
        UIHelper.showLoading()
        viewModel.addComment(comment: comment)
    }
}


extension CommentsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.className) as! CommentTableViewCell
        cell.setupWith(comment: viewModel.comments![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}


extension CommentsViewController: CommentsViewModelDelegate{
    func addCommentDidSucceed() {
        UIHelper.hideLoading()
    }
    func addCommentDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    func fetchCommentsDidSucceed() {
        UIHelper.hideLoading()
        commentsTableView.reloadData()
    }
    func fetchCommentsDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
}
