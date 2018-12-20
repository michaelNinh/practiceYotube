//
//  Video.swift
//  youtube_practice
//
//  Created by Michael Ninh on 9/16/18.
//  Copyright © 2018 Michael Ninh. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    
    var channel: Channel?
}

class Channel: NSObject{
    var name: String?
    var profileImageName: String?
    
}
