//
//  ChangeBackgroundVC.swift
//  MadlyRad
//
//  Created by Alex Titov on 1/30/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import UIKit

class ChangeBackgroundVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationItem.title = "Change Background"
        view.backgroundColor = .green
        
    }
    
    
}
