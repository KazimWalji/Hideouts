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
    
    var colorImage: UIImage
    var whiteImage: UIImage
    
    var starPlayerLooper: AVPlayerLooper
    var queuePlayer: AVQueuePlayer
    var playerLayer: AVPlayerLayer
    
    init(frame: CGRect) {
        self.view = UIView(frame: frame)
        self.background = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        guard let colorImage = UIImage(named: "starStillColor") else { fatalError("Star image is not found") }
        self.colorImage = colorImage
        guard let whiteImage = UIImage(named: "starStillWhite") else { fatalError("Star image is not found") }
        self.whiteImage = whiteImage
        self.view.addSubview(self.background)
        
        guard let animationPath = Bundle.main.path(forResource: "Star Animation", ofType: "mp4") else { fatalError("Star Animation is not found") }
        let animationURL = URL(fileURLWithPath: animationPath)
        var videoAsset = AVAsset(url: animationURL)

        let playerItem = AVPlayerItem(asset: videoAsset)
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        self.starPlayerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
                
        self.playerLayer = AVPlayerLayer(player: queuePlayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.compositingFilter = "screenBlendMode"
        queuePlayer.play()
    }
    
    func setBackgroundColored(animating: Bool) {
        
        if background.superview != nil {
            background.removeFromSuperview()
        }
        if playerLayer.superlayer != nil {
            playerLayer.removeFromSuperlayer()
        }
        
        if animating {
            view.layer.addSublayer(playerLayer)
        } else {
            background.setImage(colorImage)
            view.addSubview(background)
        }
        
    }
    
    func setBackgroundBW(white: Bool) {
        
        if background.superview != nil {
            background.removeFromSuperview()
        }
        if playerLayer.superlayer != nil {
            playerLayer.removeFromSuperlayer()
        }
        
        if white {
            background.setImage(whiteImage)
            view.addSubview(background)
        } else {
            background.setImage(UIImage())
            view.addSubview(background)
        }
        
    }
    
    
}
