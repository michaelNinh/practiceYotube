//
//  SettingsLauncher.swift
//  youtube_practice
//
//  Created by Michael Ninh on 9/22/18.
//  Copyright © 2018 Michael Ninh. All rights reserved.
//

import UIKit


// creating a Model Object to represent each option in the settings launcher
class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName:String ){
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String{
  case Settings = "Settings"
  case TermsPrivacy = "Terms and Privacy"
  case SendFeedback = "Send Feedback"
  case SwitchAccounts = "Switch Accounts"
  case Cancel = "Cancel"
}

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight:CGFloat = 50.0
    
    let settings: [Setting] = {
      let cancelSetting = Setting(name: .Cancel, imageName: "devilIcon")
      let settingsSetting = Setting(name: .Settings, imageName: "devilIcon")
      let termsSetting = Setting(name: .TermsPrivacy, imageName: "devilIcon")
      let feedbackSetting = Setting(name: .SendFeedback, imageName: "devilIcon")
      let switchAccountSetting = Setting(name: .SwitchAccounts, imageName: "devilIcon")
      
      return [settingsSetting, termsSetting, feedbackSetting, switchAccountSetting, cancelSetting]

//        return  [Setting(name: "Settings", imageName: "devilIcon"), Setting(name: "Terms and Privacy", imageName: "devilIcon"), Setting(name: "Send Feedback", imageName: "wineIcon"), Setting(name: "Help", imageName: "devilIcon"), Setting(name: "switch accounts", imageName: "devilIcon"),cancelSetting]
    }()
  
  var homeController: HomeController?
    
    func showSettings(){
        
        //        select the entire UI screen
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            
            let height:CGFloat = CGFloat(settings.count) * cellHeight 
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }, completion: nil)
            
        }
    }
  
  @objc func handleDismiss(setting: Setting){
    UIView.animate(withDuration:  0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      
      UIView.animate(withDuration: 0.5) {
        self.blackView.alpha = 0
        
        if let window = UIApplication.shared.keyWindow {
          
          self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }
      }
      
    }) { (Bool) in
      
      if setting.name != .Cancel{
        self.homeController?.showControllerForSetting(setting: setting as! Setting)
      }
      
//      something weird is going on here. This is different from the tutorial because of swift 4 syntax
//      if setting is Setting && (setting as! Setting).name != "Cancel"{
//        self.homeController?.showControllerForSetting(setting: setting as! Setting)
//      }
    }
  }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
//    reducing the amount of space between the options
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
  
//Upon hitting a settings option, this lowers the setting menu and enters a new screen
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let setting = self.settings[indexPath.item]
    handleDismiss(setting: setting)
    
  }
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
}
