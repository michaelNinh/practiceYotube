//
//  ViewController.swift/Users/michaelninh/Documents/swift_youtube/youtube_practice/youtube_practice/ViewController.swift
//  youtube_practice
//
//  Created by Michael Ninh on 9/11/18.
//  Copyright © 2018 Michael Ninh. All rights reserved.
//

import UIKit


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
//  create an optional array of Video objects

  let cellId = "cellId"
  let trendingCellId = "trendingCellId"
  let subscriptionCellId = "subscriptionCell"
  
  
//  this leverages all the ApiService
    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationController?.navigationBar.isTranslucent = false

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
    
        navigationItem.titleView = titleLabel
        
        setupCollectionView()
        
        setupMenuBar()
        setupNavBarButtons()
    }
  
//  want to make a separate function to make the code cleaner. This gets called in viewDidLoad
  func setupCollectionView(){
    
//    this is to set up the horizontal scroll
    if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.scrollDirection = .horizontal
//      this eliminates space between all cells
      flowLayout.minimumLineSpacing = 0
    }
    collectionView?.backgroundColor = UIColor.white
    
    collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
    collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
    
    //        menu bar is 50px tall
    collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    
//    this is how you get collectionViewCells to snap in pagination style
    collectionView?.isPagingEnabled = true
    
  }
    
    func setupNavBarButtons(){
//        I replaced the icons with labels for this example...
        let searchBarButtonItem = UIBarButtonItem(title: "search", style: .plain, target: self, action: #selector(handleSearch))
//        let moreButton = UIBarButtonItem(image: UIImage(named: "devilIcon"), style: .plain, target: self, action: #selector(handleMore))
        let moreBarButtonItem = UIBarButtonItem(title: "more", style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    @objc func handleSearch(){
      
      scrollToMenuIndex(menuIndex: 3)
      
    }
  
  func scrollToMenuIndex(menuIndex: Int){
    let indexPath = NSIndexPath(item: menuIndex, section: 0)
    collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
    
    setTitleForIndex(index: menuIndex)
  }
  
  private func setTitleForIndex(index: Int){
    if let titleLabel = navigationItem.titleView as? UILabel{
      titleLabel.text = "  \(titles[index])"
    }
  }
    
//    this is structured so the settings launcher is fully responsile for this function, not the HomeController
// code only runs once if the settingsLauncher
  lazy var settingsLauncher: SettingsLauncher = {
    let launcher = SettingsLauncher()
    launcher.homeController = self
    return launcher
  }()
    
    @objc func handleMore(){
      settingsLauncher.homeController = self
        settingsLauncher.showSettings()
    
    }
  
  func showControllerForSetting(setting: Setting){
    let dummySettingViewController = UIViewController()
    dummySettingViewController.view.backgroundColor = UIColor.white
    dummySettingViewController.title = setting.name.rawValue
    navigationController?.navigationBar.tintColor = UIColor.white
//    this is how you change the title color to white
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    navigationController?.pushViewController(dummySettingViewController, animated: true)
  }
  
//  needs  to be set as a lazy var so the Menubar file can access scrollViewDidScroll
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setupMenuBar(){
        navigationController?.hidesBarsOnSwipe = true

      let redView = UIView()
      redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31, alpha: 1)
      view.addSubview(redView)
      
      view.addConstraintswithFormat(format: "H:|[v0]|", views: redView)
      view.addConstraintswithFormat(format: "V:|[v0(50)]|", views: redView)
      
        view.addSubview(menuBar)
        view.addConstraintswithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintswithFormat(format: "V:[v0(50)]", views: menuBar)

      //      this somehow handles the swipe up behavior
      menuBar.topAnchor.constraintEqualToSystemSpacingBelow(topLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
    }
  
//  This is needed to match the horizontal swipe screen to the navigation bar. This method detects the X value
//  this function needs to be called by the MenuBar
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
  }
  
  
  let titles = ["Home","Trending","Subscriptions","Account",]
  
//  this handle highlighting the selected page. Not totally sure how it works. Reference Episode 12.
  override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    print(targetContentOffset.pointee.x / view.frame.width)
    let index = targetContentOffset.pointee.x / view.frame.width
    let indexPath = NSIndexPath(item: Int(index), section: 0)
    menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
    
//    this is how you handle changing the Title as the navigation changes
    setTitleForIndex(index: Int(index))
    
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    this is where different feeds are loaded 0 == home, 1 == trending, etc...fires off the correct fetch when on the page
    
    let identifier:String
    if indexPath.item == 1{
      identifier = trendingCellId
    } else if indexPath.item == 2{
      identifier = subscriptionCellId
    } else{
      identifier = cellId
    }
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    
  
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
//    the minus 50 value is from the height of the MenuBar
    return CGSize(width: view.frame.width, height: view.frame.height - 50)
  }

    
}

