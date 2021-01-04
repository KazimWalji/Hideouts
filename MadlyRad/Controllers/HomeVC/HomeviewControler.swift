//
//  HomeviewControler.swift
//  MadlyRad
//
//  Created by JOJO on 9/7/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class HomeViewController: UIViewController {
    
    private var playerLooper: AVPlayerLooper?
    
    private var girlWithWaterImageTopConstraint: NSLayoutConstraint?
    private var girlWithWaterImageHeightConstraint: NSLayoutConstraint?
    
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
        setupBackground()
        
        navigationController?.navigationBar.isHidden = true
//        setupInfluencersButton()
        // starsButton()
    }
    
    private func setupBackground() {
        setupBackgroundAnimation()
        setupBackgroundImage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupBackgroundAnimation() {
        guard let animationPath = Bundle.main.path(forResource: "Star Fractal Noise", ofType: "mp4") else { return }
        let animationURL = URL(fileURLWithPath: animationPath)
        var videoAsset = AVAsset(url: animationURL)
        
        let playerItem = AVPlayerItem(asset: videoAsset)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        
        let videoView = UIView(frame: .zero)
        layoutVideoView(videoView: videoView)
        let playerLayer = AVPlayerLayer(player: queuePlayer)
        view.layoutIfNeeded()
        playerLayer.frame = videoView.frame
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        queuePlayer.play()
    }
    
    private func layoutVideoView(videoView: UIView) {
        videoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoView)
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: view.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
        ])
    }
    
    private func setupBackgroundImage() {
        setupGirlAndWaterImage()
        setupFullBackgroundImage()
    }
    
    private func setupGirlAndWaterImage() {
        let imageView = UIImageView(frame: .zero)
        layoutGirlAndWaterImageView(imageView)
        configureGirlAndWaterImageView(imageView)
    }
    
    private func layoutGirlAndWaterImageView(_ imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        girlWithWaterImageTopConstraint = imageView.topAnchor.constraint(equalTo: view.topAnchor)
        
        guard let girlWithWaterImageTopConstraint = girlWithWaterImageTopConstraint else { return }
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            girlWithWaterImageTopConstraint,
            imageView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configureGirlAndWaterImageView(_ imageView: UIImageView) {
        imageView.image = #imageLiteral(resourceName: "girl_and_water")
        imageView.contentMode = .scaleAspectFit
        
        view.layoutIfNeeded()
        
        guard let imageSize = imageView.image?.size else { return }
        let ratio = (imageSize.height / imageSize.width)
        
        let imageViewHieght = view.bounds.width * ratio
        
        
        girlWithWaterImageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageViewHieght)
        girlWithWaterImageTopConstraint?.isActive = false
        girlWithWaterImageHeightConstraint?.isActive = true
        imageView.layoutIfNeeded()
    }
    
    private func setupFullBackgroundImage() {
        let imageView = UIImageView(frame: .zero)
        layoutFullBackgroundImageView(imageView)
        configureFullBackgroundImageView(imageView)
    }
    
    private func layoutFullBackgroundImageView(_ imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor),
        ])
    }
    
    private func configureFullBackgroundImageView(_ imageView: UIImageView) {
        imageView.image = #imageLiteral(resourceName: "girl_standing_on_rock")
        imageView.layer.compositingFilter = "screenBlendMode"
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
