//
//  FilterViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class FilterViewController: BaseViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var lowestButton: UIButton!
    @IBOutlet weak var highestButton: UIButton!
    @IBOutlet weak var newestButton: UIButton!
    @IBOutlet weak var identicalButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var subCategoryTextField: UITextField!

    
    private let citiesPicker = UIPickerView()
    private let categoriesPicker = UIPickerView()
    private let subCategoriesPicker = UIPickerView()

    private var inputAccessoryBar: UIToolbar!
    var viewModel: FilterViewModel!
    var searchWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureUI()
        fetchData()
    }
    

    func configureViewModel(){
        viewModel = FilterViewModel(view: self)
    }
    func fetchData(){
        viewModel.getCategories()
        viewModel.getCitites()
        if Defaults[.user] != nil {
            viewModel.searchRequest.clientID = Defaults[.user]!.id
        }
    }
    func configureUI(){
        cityTextField.isEnabled = false
        categoryTextField.isEnabled = false
        if searchWord != nil{
            searchTextField.text = searchWord!
        }
    }
    
    @IBAction func didPressOnOrderType(_ sender: UIButton){
        viewModel.searchRequest.order = sender.tag
        sender.tag == 1 ? makeButtonActive(button: lowestButton) : makeButtonInactive(button: lowestButton)
        sender.tag == 2 ? makeButtonActive(button: newestButton) : makeButtonInactive(button: newestButton)
        sender.tag == 3 ? makeButtonActive(button: highestButton) : makeButtonInactive(button: highestButton)
        sender.tag == 4 ? makeButtonActive(button: identicalButton) : makeButtonInactive(button: identicalButton)

    }
    
    @IBAction func didPressSearch(_ sender: UIButton){
        if let search = searchTextField.text{
            viewModel.searchRequest.searchWord = search
        }
        let vc = ProductsViewController.nib()
        vc.viewModel = ProductsViewModel(view: vc)
        vc.viewModel.searchRequest = viewModel.searchRequest
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func makeButtonActive(button: UIButton){
        button.backgroundColor = .themeColor
        button.layer.borderColor = UIColor.themeColor.cgColor
        button.setTitleColor(.white, for: .normal)
    }
    
    func makeButtonInactive(button: UIButton){
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.setTitleColor(.darkGray, for: .normal)
    }
}

extension FilterViewController: FilterViewModelDelegate{
    func getCatsDidSucceed() {
        categoriesPicker.delegate = self
        categoriesPicker.dataSource = self
        categoryTextField.inputView = categoriesPicker
        categoryTextField.inputAccessoryView = inputAccessoryBar
        subCategoriesPicker.delegate = self
        subCategoriesPicker.dataSource = self
        subCategoryTextField.inputView = subCategoriesPicker
        subCategoryTextField.inputAccessoryView = inputAccessoryBar
        categoryTextField.isEnabled = true
    }
    func getCatsDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func getCitiesDidSucceed() {
        citiesPicker.delegate = self
        citiesPicker.dataSource = self
        cityTextField.inputView = citiesPicker
        cityTextField.inputAccessoryView = inputAccessoryBar
        cityTextField.isEnabled = true
    }
    
    func getCitiesDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
}


extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView{
        case citiesPicker:
            return viewModel.cities!.count + 1
        case categoriesPicker:
            return viewModel.categories!.count + 1
        case subCategoriesPicker:
            return (viewModel.subCategories?.count ?? 0) + 1
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return " "
        }
        switch pickerView{
        case citiesPicker:
            return viewModel.cities![row - 1].name
        case categoriesPicker:
            return viewModel.categories![row - 1].title
        case subCategoriesPicker:
            return viewModel.subCategories![row - 1].title
        default: return " "
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row != 0 else {
            return
        }
        if pickerView == categoriesPicker{
            subCategoryTextField.text = ""
            viewModel.searchRequest.categoryID = viewModel.categories![row - 1].id
            categoryTextField.text = viewModel.categories![row - 1].title
            if (viewModel.categories![row - 1].id == 4) || (viewModel.categories![row - 1].id == 5){
                subCategoryTextField.isEnabled = false
            }else {
                viewModel.filterSubCats(id: viewModel.categories![row - 1].id)
                subCategoryTextField.isEnabled = true
                
            }
        }else if pickerView == subCategoriesPicker{
            subCategoryTextField.text = viewModel.subCategories![row - 1].title
            viewModel.searchRequest.categoryID = viewModel.subCategories![row - 1].id
        }else if pickerView == citiesPicker{
            viewModel.searchRequest.cityID = viewModel.cities![row - 1].id
            cityTextField.text = viewModel.cities![row - 1].name
            
        }
    }
    
    
}
