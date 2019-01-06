//
//  FeedCell.swift
//  youtube_practice
//
//  Created by michael ninh on 1/5/19.
//  Copyright © 2019 Michael Ninh. All rights reserved.
//

import UIKit

class FeedCell: BaseCell, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
  
  
//  lazy var means can access self inside closure block
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = UIColor.white
    cv.dataSource = self
    cv.delegate = self
    return cv
  }()
  
  var videos: [Video]?
  let cellId = "cellId"
  
  func fetchVideos(){
    Apiservice.sharedInstance.fetchVideo { (videos: [Video]) in
      self.videos = videos
      self.collectionView.reloadData()
    }
  }
  
  override func setupViews() {
    super.setupViews()
    
    fetchVideos()
    
    backgroundColor = UIColor.red
    addSubview(collectionView)
    addConstraintswithFormat(format: "H:|[v0]|", views: collectionView)
    addConstraintswithFormat(format: "V:|[v0]|", views: collectionView)
    
    collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  ////    this section dictates how many rows are created
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // return the amount of videos within the video array
    
    //        pattern to get past an optional videos?, since this can only take non-optional values
    return videos?.count ?? 0
  }
  
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        need to define the cell to become a VideoCell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
    cell.video = videos?[indexPath.item]
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        9/16 -> an aspect ratio math
    let height = (frame.width - 16 - 16) * 9/16
    //        68 -> sum of vertical pixel contraints
    return CGSize(width: frame.width, height: height + 16 + 88)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  
  
  
}
