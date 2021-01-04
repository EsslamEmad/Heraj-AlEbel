//
//  CategoryTableViewCell.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 28/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

protocol CategoryTableViewCellDelegate: class{
    func didPressOnCategory(index: Int)
}

class CategoryTableViewCell: UITableViewCell{
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    weak var delegate: CategoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func didPressOnCategory(_ sender: UIButton){
        delegate?.didPressOnCategory(index: sender.tag)
    }
}
