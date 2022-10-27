//
//  AppDelegate.swift
//  TopOfTopSoccer
//
//  Created by Jay on 27/10/22.
//

import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    var appNavigation:UINavigationController?
    var selectedPlayersIds = [NSNumber]()
    var selectedTeamsIds = [NSNumber]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initialVC()
        return true
    }
    
    //MARK: - InitialVC Method
    func initialVC() {
        APP_DELEGATE.appNavigation = UINavigationController(rootViewController: loadVC(strStoryboardId: SB_MAIN, strVCId: idViewController))
        APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
        APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
    }
}

