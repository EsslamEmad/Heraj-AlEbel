//
//  ProductViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 2/11/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import ImageSlideshow
import SwiftEntryKit


class ProductViewController: BaseViewController {

    @IBOutlet weak var productImages: ImageSlideshow!
    @IBOutlet weak var publisherImage: UIImageView!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var publisherImage2: UIImageView!
    @IBOutlet weak var publisherNameLabel2: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var referenceNumberLabel: UILabel!
    @IBOutlet weak var detailtsTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var relatedPhoto1: UIImageView!
    @IBOutlet weak var relatedPhoto2: UIImageView!
    @IBOutlet weak var relatedPhoto3: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    
    var viewModel: ProductViewModel!
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard images.count == 0 else { return}
        DispatchQueue.main.async{
            var imageInputs = [KingfisherSource]()
            for img in self.viewModel.product!.photos {
                if let url = URL(string: img.thumb){
                    imageInputs.append(KingfisherSource(url: url))
                    self.images.append(UIImage(data: try! Data(contentsOf: url))!)
                }
            }
            self.productImages.setImageInputs(imageInputs)
            self.productImages.contentScaleMode = .scaleAspectFill
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
            self.productImages.addGestureRecognizer(gestureRecognizer)
            UIHelper.hideLoading()
        }
        fetchRelatedProducts()
    }
    
    func fetchRelatedProducts(){
        self.viewModel.fetchRelatedProducts()
    }
    
    func configureUI(){
        UIHelper.showLoading()
        let product = viewModel.product
        
        if let img = product?.user.photo, let url = URL(string: img){
            publisherImage.kf.setImage(with: url)
            publisherImage2.kf.setImage(with: url)

        }
        publisherNameLabel.text = product?.user.name
        publisherNameLabel2.text = product?.user.name
        productNameLabel.text = product?.title
        cityLabel.text = product?.city.name
        categoryLabel.text = product?.category.title
        referenceNumberLabel.text = String(product!.referenceNumber)
        detailtsTextView.text = product?.details
        if product!.isFavorite{
            favoriteButton.setImage(UIImage(named: "heart001 - E034"), for: .normal)
        }
        if !product!.showPhone{
            callButton.isHidden = true
        }
        if viewModel.product.userID == Defaults[.user]?.id{
            favoriteButton.alpha = 0
            reportButton.alpha = 0
            callButton.alpha = 0
            chatButton.alpha = 0
        }
        
        if Defaults[.user] == nil {
            favoriteButton.alpha = 0
            reportButton.alpha = 0
            callButton.alpha = 0
            chatButton.alpha = 0
        }
        
        //productImages.isUserInteractionEnabled = true
        //productImages.zoomEnabled = true
        
        chatButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        callButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        commentsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

        //UIHelper.hideLoading()
    }
    
    @IBAction func didPressFavorite(_ sender: UIButton){
        guard !viewModel.product.isFavorite else {
            return
        }
        viewModel.favoriteProduct()
    }
    
    @IBAction func didPressReportProduct(_ sender: UIButton){
        let vc = ReportProductViewController.nib()
        vc.viewModel = ReportProductViewModel(view: vc, product: viewModel.product)
        let attributes = SwiftEntryKitHelper.defaultAttributes
        SwiftEntryKit.display(entry: vc, using: attributes)
    }
    
    @IBAction func didPressOnRelatedPhoto(_ gesture: UITapGestureRecognizer){
        let vc = ProductViewController.nib()
        vc.viewModel = ProductViewModel(view: vc)
        vc.viewModel.product = viewModel.relatedProducts![gesture.view!.tag]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didPressOnUserAds(_ gesture: UITapGestureRecognizer){
        let vc = ProductsViewController.nib()
        vc.viewModel = ProductsViewModel(view: vc)
        vc.viewModel.userID = viewModel.product.userID
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didPressOnCall(_ sender: UIButton){
        guard let phoneNumber = viewModel.product.user.phone else {
            return
        }
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func didPressOnChat(_ sender: UIButton){
        let chatVC = ChatViewController()
        let viewModel = ChatViewModel(view: chatVC, otherUser: self.viewModel.product.user)
        chatVC.viewModel = viewModel
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func didPressOnComments(_ sender: UIButton){
        let vc = CommentsViewController.nib()
        vc.viewModel = CommentsViewModel(view: vc)
        vc.viewModel.product = viewModel.product
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didPressOnShare(_ gesture: UITapGestureRecognizer){
        let firstActivityItem = viewModel.product.title
        // If you want to put an image
        let images = self.images
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, images], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func didTap() {
        productImages.presentFullScreenController(from: self)
    }

}

extension ProductViewController: ProductViewModelDelegate{
    func fetchProductDidSucceed() {
        UIHelper.hideLoading()
        configureUI()
    }
    
    func fetchProductDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func fetchRelatedDidSucceed() {
        UIHelper.hideLoading()
        if viewModel.relatedProducts!.count > 0{
            if let img = viewModel.relatedProducts![0].photos?[0].thumb, let url = URL(string: img){
                relatedPhoto1.kf.setImage(with: url)
                relatedPhoto1.isUserInteractionEnabled = true
                relatedPhoto1.layer.borderColor = UIColor.darkGray.cgColor
                relatedPhoto1.layer.borderWidth = 1
                relatedPhoto1.layer.cornerRadius = 5
                relatedPhoto1.clipsToBounds = true
            }
            if viewModel.relatedProducts!.count > 1{
                if let img = viewModel.relatedProducts![1].photos?[0].thumb, let url = URL(string: img){
                    relatedPhoto2.kf.setImage(with: url)
                    relatedPhoto2.isUserInteractionEnabled = true
                    relatedPhoto2.layer.borderColor = UIColor.darkGray.cgColor
                    relatedPhoto2.layer.borderWidth = 1
                    relatedPhoto2.layer.cornerRadius = 5
                    relatedPhoto2.clipsToBounds = true

                }
                if viewModel.relatedProducts!.count > 2{
                    if let img = viewModel.relatedProducts![2].photos?[0].thumb, let url = URL(string: img){
                        relatedPhoto3.kf.setImage(with: url)
                        relatedPhoto3.isUserInteractionEnabled = true
                        relatedPhoto3.layer.borderColor = UIColor.darkGray.cgColor
                        relatedPhoto3.layer.borderWidth = 1
                        relatedPhoto3.layer.cornerRadius = 5
                        relatedPhoto3.clipsToBounds = true

                    }
                    
                }
            }
        }
    }
    
    func fetchRelatedDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func favoriteStateDidChangeWithState(_ state: Bool) {
        
        favoriteButton.setImage(UIImage(named: "heart001 - E034"), for: .normal)
        viewModel.product.isFavorite = true
    }
    
    func favoriteStateDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func reportProductDidSucceed() {
        reportButton.setImage(UIImage(named: "flag003 - E369"), for: .normal)
    }
    
    func reportProductDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    
}
