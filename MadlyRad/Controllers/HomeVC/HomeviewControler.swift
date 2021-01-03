//
//  HomeviewControler.swift
//  MadlyRad
//
//  Created by JOJO on 9/7/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import Foundation
import UIKit
class HomeViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil, queue: nil) { _ in
            print("I see what you did there")
        }
    }
    
    private func setupUI() {
        setupWarningLabel()
        
        view.backgroundColor = .white
//        setupInfluencersButton()
        // starsButton()
    }
    
    private func setupWarningLabel() {
        let label = UILabel(frame: .zero)
        layoutWarningLabel(label: label)
        configureWarningLabel(label: label)
    }
    
    private func layoutWarningLabel(label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 100),
            label.widthAnchor.constraint(equalToConstant: 250),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func configureWarningLabel(label: UILabel) {
        label.textColor = UIColor.black
        label.text = "More coming soon!"
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
    }
    
    private func setupInfluencersButton() {
        let button = UIButton(type: .system)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "person.3"), for: .normal)
        
        button.addTarget(self, action: #selector(showImagesPopup), for: .touchUpInside)
        button.tintColor = .purple
        self.view.addSubview(button)
        let constraints = [
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 52),
            button.heightAnchor.constraint(equalToConstant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
     private var influencersPopup: InfluencersPopupViewController?
        @objc
        func showImagesPopup() {
            influencersPopup = InfluencersPopupViewController()
            guard influencersPopup != nil else { return }
            influencersPopup!.modalPresentationStyle = .overFullScreen
    //        influencersPopup!.onShowDetail = { [weak self] data in
    //            let vc = InfluencerDetailViewController()
    //            vc.data = data
    //            self?.navigationController?.pushViewController(vc, animated: true)
    //        }
            self.present(influencersPopup!, animated: true, completion: nil)
        }

    

    @objc func buttonAction(sender: UIButton!) {
      let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
      let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeVC")
      self.present(controller, animated: false, completion: nil);
    }
        /*private func starsButton(){
            let button = UIButton(type: .system)
        view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(UIImage(systemName: "gamecontroller"), for: .normal)

          button.addTarget(self, action: #selector(starButtonPressed), for: .touchUpInside)
            button.tintColor = .purple
          self.view.addSubview(button)
        let constraints = [
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
        }
    
    @objc func starButtonPressed(sender: UIButton) {
      let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
      let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController")
      self.present(controller, animated: false, completion: nil);
    }*/

    /*@objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeVC")
            self.present(controller, animated: false, completion: nil);
        }
        
    }*/
    
 }
