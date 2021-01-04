//
//  AddProductViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 3/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class AddProductViewController: BaseViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var detailsTextView: PlaceholderTextView!
    @IBOutlet weak var showPhoneSwitch: UISwitch!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subCategoryTextField: UITextField!
    
    var ImagePicked = false
    var images = [UIImage]()
    var viewModel: AddProductViewModel!
    private let citiesPicker = UIPickerView()
    private let categoriesPicker = UIPickerView()
    private let subCategoriesPicker = UIPickerView()
    private var inputAccessoryBar: UIToolbar!
    var product = Product()

    var edit = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        fetchData()
        initializeToolbar()
        configureUI()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20.0
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func configureViewModel(){
        viewModel = AddProductViewModel(view: self)
    }
    
    func fetchData(){
        viewModel.getCitites()
        viewModel.getCategories()
    }
    
    func configureUI(){
        titleTextField.layer.borderColor = UIColor.black.cgColor
        categoryTextField.layer.borderColor = UIColor.black.cgColor
        cityTextField.layer.borderColor = UIColor.black.cgColor
        priceTextField.layer.borderColor = UIColor.black.cgColor
        detailsTextView.layer.borderColor = UIColor.black.cgColor
        subCategoryTextField.layer.borderColor = UIColor.black.cgColor
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.register(UINib(nibName: ProductPhotoCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ProductPhotoCollectionViewCell.className)
        categoryTextField.isEnabled = false
        cityTextField.isEnabled = false
        subCategoryTextField.isEnabled = false
        priceTextField.delegate = self
        if edit{
            titleTextField.text = product.title
            cityTextField.text = product.city.name
            categoryTextField.text = product.category.title
            if let price = product.price{
                priceTextField.text = String(price)}else {
                priceTextField.text = ""
            }
            detailsTextView.text = product.details
            addButton.setTitle("تعديل", for: .normal)
            detailsTextView.placeholder = ""
            for img in product.photos{
                if let img = img.thumb, let url = URL(string: img){
                    let image = UIImage(data: try! Data(contentsOf: url))
                    images.append(image ?? UIImage())
                }
            }
        }
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
    
    @IBAction func didPressAdd(_ sender: UIButton){
        if edit{
            editProduct()
            return
        }
        guard Authentication() else {
            return
        }
        UIHelper.showLoading()
        viewModel.addProduct(product: product, images: images)
    }

    private func Authentication() -> Bool {
        guard ImagePicked, let title = titleTextField.text , titleTextField.text != "", let details = detailsTextView.text, details != "", product.referenceNumber != nil, product.cityID != nil else {
            UIHelper.showAlert(withMessage: "من فضلك قم بإدخال جميع البيانات")
            return false
        }
        product.title = title
        if let price = Double(priceTextField.text ?? ""){
            product.price = price}
        product.details = details
        product.showPhone = showPhoneSwitch.isOn
        return true
    }
    
    func editProduct(){
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale
        guard let title = titleTextField.text , titleTextField.text != "",  let details = detailsTextView.text, details != "" else {
            UIHelper.showAlert(withMessage: "من فضلك قم بإدخال جميع البيانات")
            return
        }
        product.title = title
        if let price = formatter.number(from: priceTextField.text ?? ""){
            product.price = Double(truncating: price)}
        product.details = details
        product.showPhone = showPhoneSwitch.isOn
        UIHelper.showLoading()
        if ImagePicked{
            viewModel.editProduct(product: product, images: images)
        }else {
            viewModel.editProduct(product: product, images: nil)
        }
    }
}


extension AddProductViewController: AddProductViewModelDelegate{
    func addProductDidSucceed() {
        UIHelper.hideLoading()
        navigationController?.popViewController(animated: true)
        UIHelper.showAlert(withMessage: "تمت إضافة الإعلان بنجاح")
    }
    
    func addProductDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
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
        
        if edit{
            let row = (viewModel.AllCategories?.firstIndex(where: {$0.id == product.categoryID}) ?? 0) + 1
            if viewModel.AllCategories![row - 1].parentID == 0{
                product.isActive = viewModel.AllCategories![row - 1].id
                categoryTextField.text = viewModel.AllCategories![row - 1].title
                product.referenceNumber = 0
            }else {
                product.isActive =  viewModel.AllCategories![row - 1].parentID
                product.referenceNumber =  viewModel.AllCategories![row - 1].id
                subCategoryTextField.text = viewModel.AllCategories![row - 1].title
                categoryTextField.text = viewModel.AllCategories!.first(where: {$0.id == viewModel.AllCategories![row - 1].parentID})?.title
                viewModel.filterSubCats(id: viewModel.AllCategories![row -  1].parentID!)
                subCategoryTextField.isEnabled = true
            }
        }
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
    
    func editProductDidSucceed() {
        UIHelper.hideLoading()
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension AddProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    //Mark: ImagePicker
    
    @IBAction func PickImage(_ recognizer: UITapGestureRecognizer) {
        guard images.count < 10 else {
            UIHelper.showAlert(withMessage: NSLocalizedString("لا يمكنك إضافة المزيد من الصور", comment: ""))
            return
        }
        
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
            images.append(selectedImage)
            photosCollectionView.reloadData()
            ImagePicked = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Mark: CollectionView Protocols
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(6)
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: ProductPhotoCollectionViewCell.className, for: indexPath) as! ProductPhotoCollectionViewCell
        item.setupWith(img: images[indexPath.item])
        item.deleteButton.tag = indexPath.item
        item.deleteButton.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didPressDelete(_:)))
        item.deleteButton.addGestureRecognizer(gesture)
        return item
    }
    
    @objc func didPressDelete(_ gesture: UITapGestureRecognizer) {
        images.remove(at: gesture.view!.tag)
        photosCollectionView.reloadData()
        ImagePicked = true
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


extension AddProductViewController: UIPickerViewDelegate, UIPickerViewDataSource{
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
            product.referenceNumber = viewModel.categories![row - 1].id
            product.isActive =  viewModel.categories![row - 1].id
            categoryTextField.text = viewModel.categories![row - 1].title
            if (viewModel.categories![row - 1].id == 4) || (viewModel.categories![row - 1].id == 5){
                product.referenceNumber = 0
                subCategoryTextField.isEnabled = false
            }
        }else if pickerView == subCategoriesPicker{
            subCategoryTextField.text = viewModel.subCategories![row - 1].title
            product.referenceNumber = viewModel.subCategories![row - 1].id
        }else if pickerView == citiesPicker{
            product.cityID = viewModel.cities![row - 1].id
            cityTextField.text = viewModel.cities![row - 1].name

        }
    }
    
    
}


extension AddProductViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .numberPad && string != "" {
            let numberStr: String = string
            let formatter: NumberFormatter = NumberFormatter()
            formatter.locale = Locale(identifier: "EN")
            if let final = formatter.number(from: numberStr) {
                textField.text =  "\(textField.text ?? "")\(final)"
            }
            return false
        }
        return true
    }
}
