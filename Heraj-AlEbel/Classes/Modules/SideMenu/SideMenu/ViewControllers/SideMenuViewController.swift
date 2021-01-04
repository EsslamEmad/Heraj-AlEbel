//
//  SideMenuViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 23/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SideMenuSwift
import SwiftyUserDefaults


class SideMenuViewController: UIViewController{
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoritButton: UIButton!
    @IBOutlet weak var myAdsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var signOutLabel: UILabel!
    @IBOutlet weak var signOutIcon: UIImageView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var contactUsTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Defaults[.user] == nil {
            coverView.alpha = 1
            profilePicture.alpha = 0
            nameLabel.alpha = 0
            contactUsTopConstraint.constant = 24
            signOutIcon.alpha = 0
            signOutLabel.text = "تسجيل الدخول"
            signOutLabel.textColor = .themeColor
        }else {
            coverView.alpha = 0
            profilePicture.alpha = 1
            nameLabel.alpha = 1
            contactUsTopConstraint.constant = 330
            signOutIcon.alpha = 1
            signOutLabel.text = "تسجيل الخروج"
            signOutLabel.textColor = .black
            if let img = Defaults[.user]?.photo, let url = URL(string: img){
                profilePicture.kf.setImage(with: url)
            }
            nameLabel.text = Defaults[.user]?.name
        }
        
    }
    
    @IBAction func didPressSignOut(_ sender: UIButton){
        guard Defaults[.user] != nil else {
            FlowManager.shared.switchToLoginFlow()
            return
        }
        let alert = UIAlertController(title: NSLocalizedString("تسجيل الخروج", comment: ""), message: NSLocalizedString("هل أنت متأكد من رغبتك في تسجيل الخروج؟", comment: ""), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: NSLocalizedString("نعم", comment: ""), style: .default, handler: {(UIAlertAction) in
            Defaults[.user] = nil
            FlowManager.shared.switchToLoginFlow()
        })
        let noAction = UIAlertAction(title: NSLocalizedString("لا", comment: ""), style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated:  true, completion: nil)
    }
    
    @IBAction func didPressFavorite(_ sender: UIButton){
        let vc = FavoritesViewController.nib()
        let nav = sideMenuController?.contentViewController as? BaseNavigationController
        nav?.pushViewController(vc, animated: true)
        sideMenuController?.hideMenu()

    }
    
    @IBAction func didPressMyAds(_ sender: UIButton){
        let vc = MyAdsViewController.nib()
        let nav = sideMenuController?.contentViewController as? BaseNavigationController
        nav?.pushViewController(vc, animated: true)
        sideMenuController?.hideMenu()
        
    }
    
    @IBAction func didPressEditProfile(_ sender: UIButton){
        let vc = EditProfileViewController.nib()
        let nav = sideMenuController?.contentViewController as? BaseNavigationController
        nav?.pushViewController(vc, animated: true)
        sideMenuController?.hideMenu()
    }
    
    @IBAction func didPressNotifications(_ sender: UIButton){
        let vc = NotificationsViewController.nib()
        let nav = sideMenuController?.contentViewController as? BaseNavigationController
        nav?.pushViewController(vc, animated: true)
        sideMenuController?.hideMenu()
    }
    
    @IBAction func didPressChat(_ sender: UIButton){
        let vc = ContactsViewController.nib()
        let nav = sideMenuController?.contentViewController as? BaseNavigationController
        nav?.pushViewController(vc, animated: true)
        sideMenuController?.hideMenu()
    }
    
    @IBAction func didPressAboutUs(_ sender: UIButton){
        let vc = AboutUsViewController.nib()
        let nav = sideMenuController?.contentViewController as? BaseNavigationController
        nav?.pushViewController(vc, animated: true)
        sideMenuController?.hideMenu()
    }
    
    @IBAction func didPressContactsUs(_ sender: UIButton){
        let vc = ContactUsViewController.nib()
        let nav = sideMenuController?.contentViewController as? BaseNavigationController
        nav?.pushViewController(vc, animated: true)
        sideMenuController?.hideMenu()
    }
}
