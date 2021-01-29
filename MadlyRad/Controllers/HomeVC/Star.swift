//
//  Star.swift
//  MadlyRad
//
//  Created by Alex Titov on 1/29/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import Foundation
import UIKit
import AVKit

struct Star {
    var view: UIView
    var background: UIImageView
    
    var starPlayerLooper: AVPlayerLooper
    var queuePlayer: AVQueuePlayer
    var playerLayer: AVPlayerLayer
    
    init(frame: CGRect) {
        self.view = UIView(frame: frame)
        self.background = UIImageView(frame: frame)
        guard let image = UIImage(named: "starStill") else { fatalError("Star image is not found") }
        self.background.setImage(image)
        self.view.addSubview(self.background)
        
        guard let animationPath = Bundle.main.path(forResource: "Star Animation", ofType: "mp4") else { fatalError("Star Animation is not found") }
        let animationURL = URL(fileURLWithPath: animationPath)
        var videoAsset = AVAsset(url: animationURL)

        let playerItem = AVPlayerItem(asset: videoAsset)
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        self.starPlayerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
                
        self.playerLayer = AVPlayerLayer(player: queuePlayer)
        playerLayer.frame = frame
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.compositingFilter = "screenBlendMode"
        queuePlayer.play()
        
        view.layer.addSublayer(playerLayer)
    }
    
    func setBackground(animating: Bool) {
        if animating == true {
            background.removeFromSuperview()
            view.layer.addSublayer(playerLayer)
        }
        
        if animating == false {
            playerLayer.removeFromSuperlayer()
            view.addSubview(background)
        }
    }
    
}
