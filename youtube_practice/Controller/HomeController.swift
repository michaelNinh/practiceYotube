//
//  ViewController.swift/Users/michaelninh/Documents/swift_youtube/youtube_practice/youtube_practice/ViewController.swift
//  youtube_practice
//
//  Created by Michael Ninh on 9/11/18.
//  Copyright © 2018 Michael Ninh. All rights reserved.
//

import UIKit


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos: [Video]?
    
    func fetchVideos(){
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
      
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
//            pattern to attempt parse JSON
//            the following DO block creates VIDEO + CHANNELS objects to pass over to videoCell
            do {
//                JSON is an array of dictionarys
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.videos = [Video]()
                
//                downcast json objects as an array of dictionaryObjects
                for dictionary in json as! [[String: AnyObject]]{
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
//                    channel information is stored as a sub dict inside the main dict
                    let channelDictionary = dictionary["channel"] as!  [String:AnyObject]
                    
                    let channel = Channel()
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    channel.name = channelDictionary["name"] as? String
                    
                    video.channel = channel
                    
                    self.videos?.append(video)
                }
//                !!! this is apparently a very important step. Need to get back onto the main threa
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
        navigationController?.navigationBar.isTranslucent = false

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "home"
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
    let settingsLauncher = SettingsLauncher()
    
    @objc func handleMore(){
        settingsLauncher.showSettings()
    }
    
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar(){
        view.addSubview(menuBar)
        view.addConstraintswithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintswithFormat(format: "V:|[v0(50)]", views: menuBar)
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

