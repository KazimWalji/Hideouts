//
//  HomeVC.swift
//  MadlyRad
//
//  Created by JOJO on 7/26/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import SAConfettiView

class HomeVC: UIViewController {
   /*
    @IBAction func musicSelection(_ sender: UIButton) {
        musicCollection.forEach{ (MusicBtn) in
            UIView.animate(withDuration: 0.4, animations: {
                MusicBtn.isHidden = !MusicBtn.isHidden
                
            })
        }
    }
    
    
    @IBAction func musicChoices(_ sender: UIButton) {
    }
    
    @IBOutlet var musicCollection: [UIButton]!
    @IBOutlet weak var Musicselect: UIButton!
    
    
    @IBAction func appleMusicButton(_ sender: Any) {
        let application = UIApplication.shared
        let itunesWebsiteUrl = URL(string: "https://music.apple.com")!
        application.open(itunesWebsiteUrl)
    }
    @IBAction func spotifyButton(_ sender: Any) {
        let application = UIApplication.shared
        
        let spotifyAppPath = "spotify://"
        
        let spotifyUrl = URL(string: spotifyAppPath)!
        
        let spotifyWebsiteUrl = URL(string: "https://apps.apple.com/us/app/spotify-music-and-podcasts/id324684580")!
        
        if application.canOpenURL(spotifyUrl) {
            application.open(spotifyUrl, options: [:], completionHandler: nil)
        } else{
            application.open(spotifyWebsiteUrl)
        }
    }
    @IBAction func youtubeMusicButton(_ sender: Any) {
        let application = UIApplication.shared
        let youtubeWebsiteUrl = URL(string: "https://youtube.com/")!
            application.open(youtubeWebsiteUrl, options: [:], completionHandler: nil)
    }
*/

    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel()
        //musicCollection.forEach { (MusicBtn) in MusicBtn.isHidden = true}
       // let storyboard = UIStoryboard(name: "homeVC", bundle: nil)
        //let controller = storyboard.instantiateViewController(withIdentifier: "HomeVC")
       // self.present(controller, animated: false, completion: nil);
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .right
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundimageforhideouts.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        view.addGestureRecognizer(edgePan)
        NotificationCenter.default.addObserver(
               forName: UIApplication.userDidTakeScreenshotNotification,
               object: nil, queue: nil) { _ in
                 print("I see what you did there")
             }

    }
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let confettiView = SAConfettiView(frame: self.view.bounds)
           confettiView.type = .Image(UIImage(named: "tripleGopher")!)
          confettiView.type = .Image(UIImage(named: "normalGopher")!)
           confettiView.type = .Image(UIImage(named: "girlGopher")!)
           confettiView.intensity = 0.3
           view.addSubview(confettiView)
            confettiView.startConfetti()
           let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
           confettiView.stopConfetti()
                
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
          //  let controller = storyboard.instantiateViewController(withIdentifier: "ShakingcoolVC")
            //self.present(controller, animated: true, completion: nil)
            
        }
        }
    }
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeVC")
            self.present(controller, animated: false, completion: nil);
        }
        
    }
    private func warningLabel(){
        let label: UILabel = UILabel()
        label.frame = CGRect(x: 100, y: 150, width: 200, height: 50)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.text = "More to come, but swipe left"
        label.numberOfLines = 0
        self.view.addSubview(label)

    }

    }
