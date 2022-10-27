//
//  ViewController.swift
//  TopOfTopSoccer
//
//  Created by Jay on 27/10/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBActions
    @IBAction func btnTopAction(_ sender: UIButton) {
        let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idTopTeamsPlayersVC)
        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
    }
    @IBAction func btnWorldRatingAction(_ sender: UIButton) {
        let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idWorldRatingsVC)
        APP_DELEGATE.appNavigation?.pushViewController(vc, animated: true)
    }
}

