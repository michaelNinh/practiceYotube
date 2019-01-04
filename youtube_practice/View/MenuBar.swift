
//
//  MenuBar.swift
//  youtube_practice
//
//  Created by Michael Ninh on 9/13/18.
//  Copyright © 2018 Michael Ninh. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["devilIcon", "snorkelIcon", "wineIcon", "playstationIcon"]
    
    override init(frame: CGRect){
        super.init(frame:frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintswithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintswithFormat(format: "V:|[v0]|", views: collectionView)
        
        
//        this code sets up a single highlighted option right on load up (index = 1 is already selected)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
      
      setupHorizontalBar()
        
    }
  
//  this is needed for animating the bar. not sure why
  var horizontalBarLeftAnchorConstraint:NSLayoutConstraint?
  
  func setupHorizontalBar(){
    let horizontalBarView = UIView()
    horizontalBarView.backgroundColor = UIColor(white: 0.8, alpha: 1)
    horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(horizontalBarView)
    
//    this bunch of code creates the white bar that animates.
    horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraintEqualToSystemSpacingAfter(self.leftAnchor, multiplier: 0)
    horizontalBarLeftAnchorConstraint?.isActive = true
    
    horizontalBarView.bottomAnchor.constraintEqualToSystemSpacingBelow(self.bottomAnchor, multiplier: 0).isActive = true
    horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
    horizontalBarView.heightAnchor.constraint(equalToConstant: 8).isActive = true
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath.item)
//    needed to divde by 4 because frame.width is the entire width of the screen. Causes the bar to move off screen?
    let x = CGFloat(indexPath.item) * frame.width/4
    horizontalBarLeftAnchorConstraint?.constant = x
    
//    how to handle the nice spring animation 
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.layoutIfNeeded()
    }, completion: nil)
    
    
    
  }
    
//    this is usually always one section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
//    return the number of cells in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
//        this allows us to modify the color of the imageViews
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor(red: 91, green: 14, blue: 13, alpha: 1)
        
        return cell
    }
    
//    set the sizing of the cells. Since there are four buttons, we set the cell width to be frame.width/4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
//    set the space between the cells to be zero (so they are all touching each other)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MenuCell: BaseCell{
    
    let imageView:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "devilIcon")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor(red: 91, green: 14, blue: 13, alpha: 1)
        return iv
    }()
    
    
//     code that runs when a cell is selected
    override var isHighlighted: Bool{
        didSet {
//             ?  (ternary operation) shortcut if / else statement
            imageView.tintColor = isHighlighted ? UIColor.black : UIColor(red: 91, green: 14, blue: 13, alpha: 1)
        }
    }
    
    override var isSelected: Bool{
        didSet {
            imageView.tintColor = isSelected ? UIColor.black : UIColor(red: 91, green: 14, blue: 13, alpha: 1)
        }
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addConstraintswithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintswithFormat(format: "V:[v0(28)]", views: imageView)
        
        
        // this centers the icons within the cell
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
}











