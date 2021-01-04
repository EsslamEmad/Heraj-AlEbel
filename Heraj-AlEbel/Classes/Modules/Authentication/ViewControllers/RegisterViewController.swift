//
//  RegisterViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 23/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
   // @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    // MARK: - Variables
    var viewModel: RegisterationViewModel?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
    }
    
    // MARK: - View model helpers
    private func setupViewModel() {
        viewModel = RegisterationViewModel(view: self)
    }
    
    //mMARK: - UI Helpers
    private func setupUI() {
        localizeView()
    }
    
    private func localizeView() {
        nameTextField.placeholder = Localization.Registeration.NamePlaceholder
        phoneTextField.placeholder = Localization.Registeration.PhonePlaceholder
       // emailTextField.placeholder = Localization.Registeration.EmailPlaceholder
        passwordTextField.placeholder = Localization.Registeration.PasswordPlaceholder
        repeatPasswordTextField.placeholder = Localization.Registeration.RepeatedPasswordPlaceholder
        registerButton.setTitle(Localization.Registeration.RegisterButtonTitle, for: .normal)
        phoneTextField.keyboardType = .asciiCapableNumberPad
    }
    
    // MARK: - Actions
    @IBAction func registerTapped(_ sender: UIButton) {
        view.endEditing(true)
        guard validCredentials() else {
            UIHelper.showAlert(withMessage: Localization.Registeration.FillAllFieldsMessage)
            return
        }
        guard passwordsMatch() else {
            UIHelper.showAlert(withMessage: Localization.Registeration.PasswordsDontMatchMessage)
            return
        }
        /*guard let picutre = selectedProfilePicture else {
         UIHelper.showAlert(withMessage: Localization.Registeration.ChoosePhotoMessage)
         return
         }*/
        UIHelper.showLoading()
        viewModel?.registerUser(name: nameTextField.text!, phone: phoneTextField.text!, password: passwordTextField.text!)
        
    }
    
    
    
    // MARK: - Helpers
    private func validCredentials() -> Bool {
        return nameTextField.text != nil && !nameTextField.text!.isEmpty && phoneTextField.text != nil && !phoneTextField.text!.isEmpty && passwordTextField.text != nil && !passwordTextField.text!.isEmpty && repeatPasswordTextField.text != nil && !repeatPasswordTextField.text!.isEmpty
    }
    
    private func passwordsMatch() -> Bool {
        return passwordTextField.text == repeatPasswordTextField.text
    }
    
}

extension RegisterViewController: RegisterationViewModelDelegate {
    
    func registerationDidSucceed() {
        UIHelper.hideLoading()
        FlowManager.shared.switchToMainFlow()
    }
    
    func registerationDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
}
