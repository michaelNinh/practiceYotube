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
    var videos: [Video]?
  
  
//  this leverages all the ApiService
  func fetchVideos(){
    Apiservice.sharedInstance.fetchVideo { (videos: [Video]) in
      self.videos = videos
      self.collectionView?.reloadData()
      
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
        navigationController?.navigationBar.isTranslucent = false

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
    
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        
//        menu bar is 50px tall
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupNavBarButtons(){
//        I replaced the icons with labels for this example...
        let searchBarButtonItem = UIBarButtonItem(title: "search", style: .plain, target: self, action: #selector(handleSearch))
        
//        let moreButton = UIBarButtonItem(image: UIImage(named: "devilIcon"), style: .plain, target: self, action: #selector(handleMore))
        
        let moreBarButtonItem = UIBarButtonItem(title: "more", style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    @objc func handleSearch(){
        print(123)
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
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
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

    
//    this section dictates how many rows are created
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the amount of videos within the video array
        
//        pattern to get past an optional videos?, since this can only take non-optional values
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        need to define the cell to become a VideoCell 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        
        cell.video = videos?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        9/16 -> an aspect ratio math
        let height = (view.frame.width - 16 - 16) * 9/16
//        68 -> sum of vertical pixel contraints
        return CGSize(width: view.frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

