//
//  LoadingHud.swift
//  OneLifeToGo
//
//  Created by Admin on 30/07/18.
//  Copyright © 2018 el. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class LoadingHUD  : NSObject{
    
    static var bgview = UIView()
    static var loaderbgview = UIView()
    
    class func showHUD(view:UIView){
        self.bgview.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        self.bgview.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        
        self.loaderbgview.frame = CGRect(x: bgview.frame.width/2-40, y: bgview.frame.height/2-40, width:80, height: 80)
        self.loaderbgview.backgroundColor = UIColor.white
        self.loaderbgview.cornerRadius = 10
        self.loaderbgview.clipsToBounds = true

        var animationView:AnimationView = AnimationView()
        animationView = AnimationView(name: "loader")
        animationView.frame = CGRect(x: 20, y: 20, width:60, height: 60)
        animationView.center = self.loaderbgview.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.stop()
        
        self.bgview.addSubview(loaderbgview)
        self.bgview.addSubview(animationView)
        animationView.play()
        view.addSubview(bgview)
    }
    
    class func showHUD(){
        LoadingHUD.showHUD(view: UIApplication.shared.windows[0])
    }
  
    class func dismissHUD(){
        self.bgview.removeFromSuperview()
    }
    
}
