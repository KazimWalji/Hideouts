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
        view.backgroundColor = .clear
        
        setupIU()
        
    }
    
    private func setupIU() {
        setupBackground()
        
    }
    
    private func setupBackground() {
        let background = UIImageView(frame: view.frame)
        background.bounds = view.bounds
        background.image = #imageLiteral(resourceName: "purpleBackground")
        view.addSubview(background)
    }
}
