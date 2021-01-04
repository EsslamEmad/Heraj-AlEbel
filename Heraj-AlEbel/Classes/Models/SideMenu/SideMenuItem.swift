//
//  SideMenuItem.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 10/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit

enum SideMenuItemType {
    case profile
    case orders
    case favorites
    case notifications
    case aboutUs
    case contactUs
    case changeLanguage
    case prefrences
    case logout
    case rechargeWallet
}

struct SideMenuItem {
    let title: String
    let image: UIImage
    let type: SideMenuItemType
}
