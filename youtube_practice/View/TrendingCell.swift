//
//  TrendingCellCollectionViewCell.swift
//  youtube_practice
//
//  Created by michael ninh on 1/6/19.
//  Copyright © 2019 Michael Ninh. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
  
  override func fetchVideos(){
    
    Apiservice.sharedInstance.fetchTrendingFeed { (videos: [Video]) in
      self.videos = videos
      self.collectionView.reloadData()
    }
  }
  
}
