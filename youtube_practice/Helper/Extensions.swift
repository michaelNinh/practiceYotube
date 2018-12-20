//
//  Extensions.swift
//  youtube_practice
//
//  Created by Michael Ninh on 9/12/18.
//  Copyright © 2018 Michael Ninh. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UIView{
    func addConstraintswithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String){
//        this is to check the correct image matches the link
        imageUrlString = urlString
        let url = NSURL(string: urlString)
        image = nil
        
//        if the image is stored in cache already, use it. if not, run the datatask
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage
        
        {
//            THIS DOES NOT WORK. THE IMAGE DOES NOT LOAD.........................
            self.image = imageFromCache
            print("using img cache")
            return
        }
        
        URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
//            load the data on another thread
            DispatchQueue.main.async {
                print("connecting to internet")
                let imageToCache = UIImage(data: data!)
                
//              this makes sure the loaded image fits the intended video
                if self.imageUrlString == urlString{
                    self.image = imageToCache
                }
                
//              this associated the urlString with the loaded image Data from cache
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
            }.resume()
    }
}

