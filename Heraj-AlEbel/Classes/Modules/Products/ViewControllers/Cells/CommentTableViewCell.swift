//
//  CommentTableViewCell.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell{
    @IBOutlet  weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.image = UIImage(named: "man")
    }
    
    func setupWith(comment: Comment){
        if let img = comment.photo, let url = URL(string: img){
            userImage.kf.setImage(with: url)
        }
        userNameLabel.text = comment.name
        commentLabel.text = comment.comment
    }
    
}
