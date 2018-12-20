//
//  ViewCell.swift
//  youtube_practice
//
//  Created by Michael Ninh on 9/12/18.
//  Copyright © 2018 Michael Ninh. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UICollectionViewCell {
    
    override init (frame:CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
//    this function is not doing anything???
    func setupViews() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(" no init coder")
    }
    
}

class VideoCell: BaseCell{
    
    var video:Video? {
//        fires this code once something is assigned to VideoCell.Video
        didSet{
            titleLabel.text = video?.title
            
            setupThumbnailImage()
            setupProfileImage()
            
            if let thumbnailImageName = video?.thumbnailImageName{
                thumbnailImageView.image = UIImage(named: thumbnailImageName)
            }
            
//            there is a double if - let pattern here
            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews{
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
            let subtitleText = "\(channelName) - \(numberFormatter.string(from: numberOfViews)!) - 2 years ago "
                subtitleTextView.text = subtitleText
            }
            
//            measure the title text here
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                
//                This might be wrong due to name "systemFont"
                let estimatedRect = NSString(string:title).boundingRect(with: size, options:options, attributes:[NSAttributedStringKey.font: UIFont.systemFont(ofSize:14)],context:nil)
                
//                takes the estimated size of rect, and sets the label spacing constraint
                if estimatedRect.size.height > 20{
                    titleLabelHeightConstraint?.constant = 44
                } else{
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
        
    }
    
    func setupThumbnailImage(){
        if let thumbnailImageUrl = video?.thumbnailImageName{
            print(thumbnailImageUrl)
//            loadImageUsringUrlString is a customer helper function that we created
            thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    func setupProfileImage() {
        if let profileImgUrl = video?.channel?.profileImageName{
            print(profileImgUrl)
            userProfileImageView.loadImageUsingUrlString(urlString: profileImgUrl)
        }
        
    }
    
    //    create image block for thumbnail
    var thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "bear Img")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //    create image block for user profile thumbnail
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "mockProfile")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //    create the divider line between video cells
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taylor Swift - Blank Space"
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
//        there is some type of weird error that occurs right here...
        textview.text = "TaylorSwiftVevo - 1,500,000,000,000 Views - 2 years ago"
        textview.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textview.textColor = UIColor.lightGray
        return textview
    }()
    
//    code to adjust the titleLable for 1 or 2 lines of text
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews(){
        
        addSubview(thumbnailImageView)
        addSubview(seperatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        addConstraintswithFormat(format:  "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintswithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        // vertical constraints of video cell
        addConstraintswithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView,userProfileImageView,seperatorView)
        addConstraintswithFormat(format:  "H:|[v0]|", views: seperatorView)
        
        
        // CONSTRAINTS FOR TITLE LABEL
        // top constraint for titleLabel -> to account for how tall a title can be (2 lines tall)
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        // left constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        // right constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height constraint !!! i am actually skipping adding a height constraint!!!

//        addConstraint(titleLabelHeightConstraint!)
        
        
        // CONSTRAINTS FOR SUBTITLE LABEL
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        // left constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        // right constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
        
        
        
    }
    
    
}
