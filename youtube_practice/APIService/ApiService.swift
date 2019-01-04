//
//  ApiService.swift
//  youtube_practice
//
//  Created by michael ninh on 1/3/19.
//  Copyright © 2019 Michael Ninh. All rights reserved.
//

import Foundation

class Apiservice: NSObject {
  
  static let sharedInstance = Apiservice()
  
  func fetchVideo(completion: @escaping (([Video]) -> ())){
    
    //      this URL is where the data is stored
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
        
        var videos = [Video]()
        
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
          videos.append(video)
        }
        //                !!! this is apparently a very important step. Need to get back onto the main threa
        DispatchQueue.main.async {
          completion(videos)
        }
      } catch let jsonError {
        print(jsonError)
      }
      }.resume()
  }
  
}
