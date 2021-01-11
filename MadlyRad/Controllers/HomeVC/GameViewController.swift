//
//  GameViewController.swift
//  star
//
//  Created by Xiaoyue Huang on 9/3/20.
//  Copyright © 2020 Xiaoyue Huang. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFit
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            gameButton()
        }
    }
    private func gameButton(){
           let button = UIButton(type: .system)
       view.addSubview(button)
           button.translatesAutoresizingMaskIntoConstraints = false
   button.setBackgroundImage(UIImage(systemName: "gamecontroller"), for: .normal)

         button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
           button.tintColor = .purple
         self.view.addSubview(button)
       let constraints = [
           button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
           button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
           button.widthAnchor.constraint(equalToConstant: 32),
           button.heightAnchor.constraint(equalToConstant: 32)
       ]
       NSLayoutConstraint.activate(constraints)
       }

       @objc func buttonAction(sender: UIButton!) {
      let controller = ChatTabBar()
         controller.modalPresentationStyle = .fullScreen
            
         self.present(controller, animated: false, completion: nil)

       }
}
