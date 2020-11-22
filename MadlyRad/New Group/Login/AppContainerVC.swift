//
//  HomeVC.swift
//  MadlyRad
//
//  Created by JOJO on 7/20/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
class AppContainerVC: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppManager.shared.appContainer = self
        AppManager.shared.showApp()
        
 
        
        
    }
}
