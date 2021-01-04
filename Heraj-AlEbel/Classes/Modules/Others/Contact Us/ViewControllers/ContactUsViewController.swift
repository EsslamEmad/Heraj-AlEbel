//
//  ContactUsViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var bankTextView: UITextView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    
    var settings: APISettings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        getData()
    }
    

    func configureUI(){
        self.title = "إتصل بنا"
        messageTextView.layer.borderColor = UIColor.themeColor.cgColor
        dataView.layer.borderColor = UIColor.lightGray.cgColor
        dataView.layer.borderWidth = 1
        dataView.layer.cornerRadius = 5
        dataView.clipsToBounds = true
        dataView.layer.shadowColor = UIColor.black.cgColor
        dataView.layer.shadowOpacity = 1
        dataView.layer.shadowOffset = .zero
        dataView.layer.shadowRadius = 10
    }
    
    func getData(){
        UIHelper.showLoading()
        RequestManager.shared.performRequest(withRoute: OthersEndPoint.getSettings, responseModel: APISettings.self) { [weak self] (result) in
            UIHelper.hideLoading()
            switch result {
            case .success(let settings):
                self?.settings = settings
                self?.bankTextView.text = settings.bankDetails
                self?.phoneLabel.text = settings.phone
                self?.emailLabel.text = settings.email
            case .failure(let error):
                UIHelper.showAlert(withMessage: error.localizedDescription)
            }
            
        }
    }
    
    @IBAction func didPressFacebook(_ sender: UIButton){
        guard let urlString = settings?.facebook, let url = URL(string: urlString) else{
            return
        }
        UIApplication.shared.open(url)
    }
   
    @IBAction func didPressTwitter(_ sender: UIButton){
        guard let urlString = settings?.twitter, let url = URL(string: urlString) else{
            return
        }
        UIApplication.shared.open(url)
    }
    @IBAction func didPressInstagram(_ sender: UIButton){
        guard let urlString = settings?.instagram, let url = URL(string: urlString) else{
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction func didPressAboutUs(_ sender: UIButton){
        let vc = AboutUsViewController.nib()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didPressSend(_ sender: UIButton){
        guard let title = titleTextField.text, title != "", let message = messageTextView.text, message != "", let phone = phoneTextField.text, phone != "", let email = emailTextField.text, email != "", let address = addressTextField.text, address != "" else {
            UIHelper.showAlert(withMessage: "من فضلك أدخل جميع البيانات")
            return
        }
        UIHelper.showLoading()
        RequestManager.shared.performRequest(withRoute: OthersEndPoint.contactUs(message: message, title: title, phone: phone, email: email, address: address), responseModel: APIMessageResponse.self){ [weak self] (result) in
            switch result{
            case .success(let msg):
                UIHelper.showAlert(withMessage: msg.message)
                UIHelper.hideLoading()
            case.failure(let error) :
                UIHelper.hideLoading()
                UIHelper.showAlert(withMessage: error.localizedDescription)
            }
        }
    }
}
