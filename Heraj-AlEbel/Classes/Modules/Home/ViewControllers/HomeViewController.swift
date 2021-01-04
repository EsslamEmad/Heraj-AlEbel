//
//  HomeViewController.swift
//  Heraj-AlEbel
//
//  Created by Esslam Emad on 23/10/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import MarqueeLabel
import SwiftyUserDefaults
import SwiftEntryKit


class HomeViewController: BaseViewController {
    
    //@IBOutlet weak var tabsContainerView: UIView!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var marqueeLabel: MarqueeLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var discountsCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var viewModel: HomeViewModel!
    let loadingDispatchGroup = DispatchGroup()
    var first = true
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        
        configureViewModel()
        configureUI()
        super.viewDidLoad()
        welcomeMessagePopUp()
        //navigationItem.title = Localization.Home.ScreenTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        setupNavigationButtons()
        configureInitialData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.leftBarButtonItems?.remove(at: 1)
        navigationItem.rightBarButtonItems?.remove(at: 0)
    }
    
    func configureViewModel(){
        viewModel = HomeViewModel(view: self)
    }

    func configureUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: ProductCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.className)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(UINib(nibName: FoursquareCategoryCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: FoursquareCategoryCollectionViewCell.className)
        discountsCollectionView.delegate = self
        discountsCollectionView.dataSource = self
        discountsCollectionView.register(UINib(nibName: DiscountedMealCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: DiscountedMealCollectionViewCell.className)
        //discountsCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.startTimer()
        })
        
        pageControl.hidesForSinglePage = true
        searchBar.backgroundImage = UIImage()
        marqueeLabel.textAlignment = .right
        marqueeLabel.type = .continuousReverse
        marqueeLabel.speed = .rate(40)
        marqueeLabel.animationCurve = .linear
        marqueeLabel.fadeLength = 10.0
        marqueeLabel.leadingBuffer = 30.0
        marqueeLabel.trailingBuffer = 20.0
        searchBar.delegate = self
        if Defaults[.user] == nil {
            addButton.alpha = 0
        }
    }
    
    func welcomeMessagePopUp(){
        guard let msg = Defaults[.user]?.firstLogin else {
            return
        }
        //Defaults[.user]!.firstLogin = nil
        let vc = WelcomeMessageViewController.nib()
        vc.msg = msg
        let attributes = SwiftEntryKitHelper.defaultAttributes
        SwiftEntryKit.display(entry: vc, using: attributes)
        
    }
    
    private func configureInitialData() {
        UIHelper.showLoading()
        loadingDispatchGroup.enter()
        viewModel.fetchCategories()
        loadingDispatchGroup.notify(queue: .main) {
            UIHelper.hideLoading()
        }
    }
    
    
    var timer: Timer!
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollAutomatically(_:)), userInfo: nil, repeats: true)
        //timer.fire()
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = discountsCollectionView {
            for cell in coll.visibleCells {
                
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                guard indexPath != nil else { return }
                
                if ((indexPath?.row)! < viewModel.Banners.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .centeredHorizontally, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: 0)
                    coll.scrollToItem(at: indexPath1!, at: .centeredHorizontally, animated: true)
                }
                
            }
        }
    }
    
    
    // MARK: - SideMenu helpers
    private func setupNavigationButtons() {
        let sideMenuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_001_e_002"), style: .plain, target: self, action: #selector(openSideMenu))
        //let logoButton = UIBarButtonItem(image: #imageLiteral(resourceName: "01-1"), style: .done, target: self, action: nil)
        //let contactUsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "phone_call"), style: .plain, target: self, action: #selector(openContactUs))
        let logoButton = UIButton()
        logoButton.setImage(#imageLiteral(resourceName: "01-1"), for: .normal)
        logoButton.imageView?.contentMode = .scaleAspectFill
        let contactUsButton = UIButton()
        contactUsButton.setImage(#imageLiteral(resourceName: "group_345"), for: .normal)
        contactUsButton.imageView?.contentMode = .scaleAspectFit
        contactUsButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        contactUsButton.addTarget(self, action: #selector(openContactUs), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems = [sideMenuButton, UIBarButtonItem(customView: logoButton)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contactUsButton)
        
    }
    
    @objc func openSideMenu() {
        sideMenuController?.revealMenu()
    }
    
    @objc func openContactUs(){
        let vc = ContactUsViewController.nib()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //Mark:- Data Fetching
    
    func fetchData(){
        UIHelper.showLoading()
        viewModel.fetchData()
    }
    
    
    @IBAction func didPressOnAddButton(_ sender: UIButton){
        let vc = AddProductViewController.nib()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didPressOnFilter(_ sender: UIButton){
        let vc = FilterViewController.nib()
        if let search = searchBar.text{
            vc.searchWord = search
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didPressOnCategories(_ sender: UIButton){
        let vc = CategoriesViewController.nib()
        vc.viewModel = CategoriesViewModel(view: vc)
        vc.viewModel?.parentID = 0
        navigationController?.pushViewController(vc, animated: true)
    }
}



//MARK: CollectionView Delegate and DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == discountsCollectionView{
                   pageControl.numberOfPages = viewModel.Banners.count
                   return viewModel.Banners.count
                   
               }
        else if collectionView == categoriesCollectionView{
        return viewModel.categories.count}
    
        return viewModel.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == discountsCollectionView{
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscountedMealCollectionViewCell.className, for: indexPath) as! DiscountedMealCollectionViewCell
                   if let url = URL(string:  viewModel.Banners[indexPath.item].photo){
                       cell.img.kf.setImage(with: url)
                       cell.img.kf.indicatorType = .activity
                   }
                   return cell
               }
        else if collectionView == categoriesCollectionView{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoursquareCategoryCollectionViewCell.className, for: indexPath) as! FoursquareCategoryCollectionViewCell
               let category = viewModel.categories[indexPath.item]
               cell.setupWith(category: category)
        return cell}
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
        cell.setupWith(product: viewModel.products![indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == discountsCollectionView{
                   
                   return
        }else if collectionView == categoriesCollectionView{
               UIHelper.showLoading()
               viewModel.selectItemAtIndex(indexPath.item)
               collectionView.reloadData()
               let category = viewModel.categories[indexPath.item]
               loadingDispatchGroup.enter()
               viewModel.fetchVenuesInCategory(category)
               loadingDispatchGroup.notify(queue: .main) {
                   UIHelper.hideLoading()
               }
        }else{
        UIHelper.showLoading()
        let vc = ProductViewController.nib()
        vc.viewModel = ProductViewModel(view: vc)
        vc.viewModel.product = viewModel.products![indexPath.item]
            navigationController?.pushViewController(vc, animated: true)}
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == discountsCollectionView {
            self.pageControl.currentPage = indexPath.item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == discountsCollectionView {
                   return CGSize(width: view.frame.width, height: 200)
        } else if collectionView == categoriesCollectionView {
               let label = UILabel()
               label.text = viewModel.categories[indexPath.item].title
        return CGSize(width: label.intrinsicContentSize.width + 40, height: 60)}
        return CGSize(width: view.frame.size.width / 2 - 20 , height: 215)
    }
}

extension HomeViewController: ProductCollectionViewCellDelegate{
    func didPressOnProduct(product: Product) {
        
    }
    
    func didPressOnCall(product: Product) {
        guard Defaults[.user] != nil else {
            let vc = LoginViewController.nib()
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        guard let phoneNumber = product.user.phone else {
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
    
    func didPressOnChat(product: Product) {
        guard Defaults[.user] != nil else {
            let vc = LoginViewController.nib()
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        let chatVC = ChatViewController()
        let viewModel = ChatViewModel(view: chatVC, otherUser: product.user)
        chatVC.viewModel = viewModel
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
}

//Mark: Home ViewModel Delegate
extension HomeViewController: HomeViewModelDelegate{
   
    
    func fetchDataDidFailWithError(_ error: Error) {
        UIHelper.hideLoading()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func fetchDataDidSucceed() {
        UIHelper.hideLoading()
        
        var str = ""
        for news in viewModel.data?.news ?? [APINews](){
            str += news.title + " * "
        }
        marqueeLabel.text = str
    }
    
    func fetchRestaurantsDidSucceed() {
        UIHelper.hideLoading()
        
        collectionView.reloadData()
        
    }
    
    func fetchRestaurantsDidFailWithError(_ error: Error) {
           UIHelper.hideLoading()
           UIHelper.showAlert(withMessage: error.localizedDescription)
       }
    
    func fetchCategoriesDidSucceed() {
        loadingDispatchGroup.leave()
        categoriesCollectionView.reloadData()
        //startTimer()
        UIHelper.showLoading()
        viewModel.selectItemAtIndex(0)
        //collectionView.reloadData()
        let category = viewModel.categories[0]
        loadingDispatchGroup.enter()
        viewModel.fetchVenuesInCategory(category)
        loadingDispatchGroup.notify(queue: .main) {
            UIHelper.hideLoading()
        }
    }
    
    func fetchCategoriesDidFailWithError(_ error: Error) {
        loadingDispatchGroup.leave()
        UIHelper.showAlert(withMessage: error.localizedDescription)
    }
    
    func getBannersDidSucceed() {
           discountsCollectionView.reloadData()
       }
}


//MARK:- Categories TableViewCell Delegate
extension HomeViewController: CategoryAdsTableViewCellDelegate{
    func didTapWatchAll(index: Int) {
        
    }
    func didTapOnProduct(product: Product) {
        
    }
}

extension HomeViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text else{
            return
        }
        var searchRequest = SearchRequest()
        searchRequest.searchWord = search
        let vc = ProductsViewController.nib()
        vc.viewModel = ProductsViewModel(view: vc)
        vc.viewModel.searchRequest = searchRequest
        navigationController?.pushViewController(vc, animated: true)
    }
}
