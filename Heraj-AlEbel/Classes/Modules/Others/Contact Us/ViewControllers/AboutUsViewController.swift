//
//  AboutUsViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class AboutUsViewController: BaseViewController {

    @IBOutlet weak var contectTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIHelper.showLoading()
        RequestManager.shared.performRequest(withRoute: OthersEndPoint.aboutUs, responseModel: APIPage.self) { [weak self] (result) in
            switch result{
            case .success(let page):
                UIHelper.hideLoading()
                self?.title = page.title
                self?.contectTextView.text = page.content
            case .failure(let error):
                UIHelper.hideLoading()
                UIHelper.showAlert(withMessage: error.localizedDescription)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
