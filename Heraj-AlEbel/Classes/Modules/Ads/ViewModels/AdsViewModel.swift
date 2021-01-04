//
//  AdsViewModel.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 28/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

protocol AdsViewModelDelegate: class {
    
}

class AdsViewModel{
    weak var view: AdsViewModelDelegate!
    var data: HomeData?
    
    init(view: AdsViewModelDelegate) {
        self.view = view
    }
}
