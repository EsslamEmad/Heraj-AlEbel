//
//  ContactTableViewCell.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setupWith(conversation: Conversation){
        if let img = conversation.otherUser.photo, let url = URL(string: img){
            userPhoto.kf.setImage(with: url)
        }
        nameLabel.text = conversation.otherUser.name
    }

}
