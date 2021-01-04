//
//  ReportProductViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 6/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftEntryKit

class ReportProductViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var reasonID: Int!
    private let reasonsPicker = UIPickerView()
    private var inputAccessoryBar: UIToolbar!
    // MARK: - Variables
    var viewModel: ReportProductViewModel!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getReasons()
    }
    
    // MARK: - UI Helpers
    
    func getReasons()
    {
        UIHelper.showLoading()
        viewModel.getReasons()
    }
    
    private func configureUI() {
        view.backgroundColor = .clear
        reasonTextField.isEnabled = false
    }
    
    
    
    // MARK: - Actions
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        guard validEntry() else {
            UIHelper.showAlert(withMessage: "من فضلك اختر السبب")
            return
        }
        UIHelper.showLoading()
        viewModel.reportProduct(reasonID: reasonID)
        
    }
    
    // MARK: - Helpers
    private func validEntry() -> Bool {
        return reasonID != nil
    }
    
    private func initializeToolbar() {
        inputAccessoryBar = UIToolbar(frame: CGRect(x: 0, y:0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(title: NSLocalizedString("تم", comment: ""), style: .done, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        inputAccessoryBar.items = [flexibleSpace, doneButton]
    }
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
}

// MARK: - CancelOrderViewModelDelegate
extension ReportProductViewController: ReportProductViewModelDelegate {
    func getReasonsDidSucceed() {
        reasonsPicker.delegate = self
        reasonsPicker.dataSource = self
        reasonTextField.inputView = reasonsPicker
        reasonTextField.inputAccessoryView = inputAccessoryBar
        reasonTextField.isEnabled = true
    }
    
    func getReasonsDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func reportDidSucceed(_ message: String) {
        UIHelper.hideLoading()
    
        SwiftEntryKit.dismiss()
        UIHelper.showAlert(withMessage: message)
    }
    
    func reportDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
}


extension ReportProductViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (viewModel.resaons?.count ?? 0) + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row != 0 else {
            return " "
        }
        return viewModel.resaons![row - 1].name
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row != 0 else {
            return
        }
        
        reasonTextField.text = viewModel.resaons![row - 1].name
        reasonID = viewModel.resaons![row - 1].id
    }
}
