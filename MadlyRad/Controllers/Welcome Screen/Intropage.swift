//
//  Intropage.swift
//  MadlyRad
//
//  Created by JOJO on 8/16/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//
/*
import Foundation
import AVKit

class IntroPage: UIViewController{
var videoPlayer:AVPlayer?

var videoPlayerLayer:AVPlayerLayer?

    @IBAction func Signup(_ sender: Any) {
        let controller = SignInVC()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
        print("asada")
    }
    override func viewDidLoad() {
        super .viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // Set up video in the background
        setUpVideo()
    }
    func setUpVideo() {
        
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "FinalVideo_1594164286.252275-1", ofType: "mp4")
        guard bundlePath != nil else {
                return
            }
            
            // Create a URL from it
            let url = URL(fileURLWithPath: bundlePath!)
            
            // Create the video player item
            let item = AVPlayerItem(url: url)
            
            // Create the player
            videoPlayer = AVPlayer(playerItem: item)
            
            // Create the layer
            videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        videoPlayerLayer?.opacity = 0.3
            // Adjust the size and frame
     
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
            
            view.layer.insertSublayer(videoPlayerLayer!, at: 0)
            
            // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 1)
        }
  
}
*/
