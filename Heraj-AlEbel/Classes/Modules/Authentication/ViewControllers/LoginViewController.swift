//
//  LoginViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 23/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    
    // MARK: - Variables
    var viewModel: LoginViewModel?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
    }
    
    // MARK: - View model helpers
    private func setupViewModel() {
        viewModel = LoginViewModel(view: self)
    }
    
    //MARK: - UI Helpers
    private func setupUI() {
        localizeView()
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
    }
    
    private func localizeView() {
        emailTextField.placeholder = Localization.Login.emailTitle
        passwordTextField.placeholder = Localization.Login.PasswordPlaceholder
        loginButton.setTitle(Localization.Login.LoginButtonTitle, for: .normal)
        forgotPasswordButton.setTitle(Localization.Login.ForgotPasswordButtonTitle, for: .normal)
        forgotPasswordLabel.text = Localization.Login.ForgotPasswordLabelTitle
        registerButton.setTitle(Localization.Login.RegisterButtonTitle, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func loginTapped(_ sender: UIButton) {
        view.endEditing(true)
        guard validCredentials() else {
            UIHelper.showAlert(withMessage: Localization.Login.InvalidCredentialsMessage)
            return
        }
        if let _ = Int(emailTextField.text ?? ""){
            viewModel?.authenticateUser(name: "", phone: emailTextField.text!, password: passwordTextField.text!)
        }else {
            viewModel?.authenticateUser(name: emailTextField.text!, phone: "", password: passwordTextField.text!)
        }
        UIHelper.showLoading()
        
    }
    
    /*@IBAction func forgotPasswordTapped(_ sender: UIButton) {
        /*let registerVC = PhoneRegisterationViewController.nib()
         registerVC.type = .forgotPassword
         navigationController?.pushViewController(registerVC, animated: true)*/
        let alert = UIAlertController(title: Localization.General.AppName, message: Localization.Login.enterYourEmailTitle, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = Localization.Login.emailTitle
        }
        let doneAction = UIAlertAction(title: Localization.General.doneTitle, style: .default, handler: {(UIAlertAction) in
            if let textField = alert.textFields?.first {
                guard let email = textField.text, email != "" else {
                    UIHelper.showAlert(withMessage: Localization.Login.enterYourEmailTitle)
                    return
                }
                UIHelper.showLoading()
                self.viewModel?.forgotPassword(email: email)
            }
        })
        let cancelAction = UIAlertAction(title: Localization.General.cancelTitle, style: .cancel, handler: nil)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }*/
    
    @IBAction func createNewAccountTapped(_ sender: UIButton) {
        let registerVC = RegisterViewController.nib()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func didPressGoToMainView(_ sender: UIButton){
        FlowManager.shared.switchToMainFlow()
    }
   
    
    // MARK: - Helpers
    func validCredentials() -> Bool {
        return passwordTextField.text != nil && !passwordTextField.text!.isEmpty && emailTextField.text != nil && !emailTextField.text!.isEmpty
    }
    
}

extension LoginViewController: LoginViewModelDelegate {
    
    func userAuthenticationDidSucceed() {
        UIHelper.hideLoading()
        FlowManager.shared.switchToMainFlow()
    }
    
    func userAuthenticationDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func forgotPasswordDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func forgotPasswordDidSucceedWithMessage(_ message: String) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: message)
    }
}
