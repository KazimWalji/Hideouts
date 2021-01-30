//
//  ChangeBackgroundVC.swift
//  MadlyRad
//
//  Created by Alex Titov on 1/30/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import UIKit

class ChangeBackgroundVC: UIViewController {
    
    private var views: [BackgroundView] = []
    private var buttons: [UIButton] = []
    private var background: UIImageView?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .clear
        
        setupIU()
        
    }
    
    private func setupIU() {
        setupBackground()
        
        let view1 = BackgroundView(frame: CGRect(x: 30, y: 70, width: 150, height: 300), image: UIImage(named: "starsBackgroundOrange")!)
        let view2 = BackgroundView(frame: CGRect(x: view.frame.width - 150 - 30, y: 70, width: 150, height: 300), image: UIImage(named: "starsBackgroundLightBlue")!)
        let view3 = BackgroundView(frame: CGRect(x: 30, y: 420, width: 150, height: 300), image: UIImage(named: "starsBackgroundDarkBlue")!)
        let view4 = BackgroundView(frame: CGRect(x: view.frame.width - 150 - 30, y: 420, width: 150, height: 300), image: UIImage(named: "starsBackgroundPurple")!)
        
        views.append(view1)
        views.append(view2)
        views.append(view3)
        views.append(view4)

        for backgroundView in views {
            let button = UIButton(frame: backgroundView.background.frame)
            button.addTarget(self, action: #selector(viewChosen), for: .touchUpInside)
            button.backgroundColor = .clear
            
            buttons.append(button)
            backgroundView.view.addSubview(button)
            
            view.addSubview(backgroundView.view)
            
        }

        
    }
    
    private func setupBackground() {
        background = UIImageView(frame: view.frame)
        background?.bounds = view.bounds
        background?.image = #imageLiteral(resourceName: "purpleBackground")
        view.addSubview(background!)
    }
    
    @objc func viewChosen(sender: UIButton) {
        let index = Int(buttons.firstIndex(of: sender)!)
        switch index {
        case 0:
            background?.image = UIImage(named: "starsBackgroundOrange")!
        case 1:
            background?.image = UIImage(named: "starsBackgroundLightBlue")!
        case 2:
            background?.image = UIImage(named: "starsBackgroundDarkBlue")!
        case 3:
            background?.image = UIImage(named: "starsBackgroundPurple")!
        default:
            fatalError("index of chosen background is not 0 - 3")
        }
            
    }
    
    
}
