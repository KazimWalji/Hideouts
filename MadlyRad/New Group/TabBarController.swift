//
//  MainViewController.swift
//  MadlyRad
//
//  Created by JOJO on 7/23/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
      guard let tabBarController = tabBarController, let viewControllers = tabBarController.viewControllers else { return }
      let tabs = viewControllers.count
      if gesture.direction == .left {
          if (tabBarController.selectedIndex) < tabs {
              tabBarController.selectedIndex += 1
          }
      } else if gesture.direction == .right {
          if (tabBarController.selectedIndex) > 0 {
              tabBarController.selectedIndex -= 1
          }
      }
    }

}
