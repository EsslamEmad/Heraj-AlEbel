//
//  EditProfileViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
   // @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    
    // MARK: - Variables
    var viewModel: EditProfileViewModel?
    var ImagePicked = false

    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
    }
    
    // MARK: - View model helpers
    private func setupViewModel() {
        viewModel = EditProfileViewModel(view: self)
    }
    
    //mMARK: - UI Helpers
    private func setupUI() {
        localizeView()
        nameTextField.text = Defaults[.user]!.name
        phoneTextField.text = Defaults[.user]!.phone
       // emailTextField.text = Defaults[.user]!.email
        phoneTextField.keyboardType = .asciiCapableNumberPad
        if let img = Defaults[.user]!.photo, let url = URL(string: img){
            profilePicture.kf.setImage(with: url)
        }
    }
    
    private func localizeView() {
        nameTextField.placeholder = Localization.Registeration.NamePlaceholder
        phoneTextField.placeholder = Localization.Registeration.PhonePlaceholder
        //emailTextField.placeholder = Localization.Registeration.EmailPlaceholder
        passwordTextField.placeholder = Localization.Registeration.PasswordPlaceholder
        repeatPasswordTextField.placeholder = Localization.Registeration.RepeatedPasswordPlaceholder
        
    }
    
    // MARK: - Actions
    @IBAction func editTapped(_ sender: UIButton) {
        view.endEditing(true)
        var user = User()
        
        guard validCredentials() else {
            UIHelper.showAlert(withMessage: Localization.Registeration.FillAllFieldsMessage)
            return
        }
        if passwordTextField.text != nil && !passwordTextField.text!.isEmpty{
            guard passwordsMatch() else {
                UIHelper.showAlert(withMessage: Localization.Registeration.PasswordsDontMatchMessage)
                return
            }
            user.password = passwordTextField.text
        }
        user.id = Defaults[.user]!.id
        user.name = nameTextField.text
        //user.email = emailTextField.text
        user.phone = phoneTextField.text
        
        UIHelper.showLoading()
        if ImagePicked{
            viewModel?.upload(user: user, image: profilePicture.image!)
        }else {
            viewModel?.editUser(user: user)
        }
        
        
    }
    
    
    
    // MARK: - Helpers
    private func validCredentials() -> Bool {
        return nameTextField.text != nil && !nameTextField.text!.isEmpty && phoneTextField.text != nil && !phoneTextField.text!.isEmpty 
    }
    
    private func passwordsMatch() -> Bool {
        return passwordTextField.text == repeatPasswordTextField.text
    }
    
}

extension EditProfileViewController: EditProfileViewModelDelegate {
    func editDidSucceed() {
        UIHelper.hideLoading()
        navigationController?.popViewController(animated: true)
        UIHelper.showAlert(withMessage: "تم تعديل الملف الشخصي")
    }
    
    func editDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    
    
    
}

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    //Mark: ImagePicker
    
    @IBAction func PickImage(_ recognizer: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("اختر طريقة رفع الصورة.", comment: ""), preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("الكاميرا", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            UIHelper.showLoading()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: {() -> Void in UIHelper.hideLoading()})
            }
            else{
                UIHelper.hideLoading()
                UIHelper.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى الكاميرا الخاصة بك", comment: ""))
            }
        })
        let photoAction = UIAlertAction(title: NSLocalizedString("مكتبة الصور", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            UIHelper.showLoading()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: {() -> Void in UIHelper.hideLoading()})
            }
            else{
                UIHelper.hideLoading()
                UIHelper.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى مكتبة الصور الخاصة بك", comment: ""))
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let infoimg = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let selectedImage = infoimg[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            profilePicture.image = selectedImage
            ImagePicked = true
        }
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
