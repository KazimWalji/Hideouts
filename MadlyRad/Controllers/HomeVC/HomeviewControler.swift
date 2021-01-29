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
    private var starPlayerLoopers: [AVPlayerLooper] = []
    
    private var nameLabels: [UILabel] = []
    private var bellClicked: Bool = false
    
    private var friends: [Friend] = []
    private var currentFriend: Friend?
    
    //temporary data for NotificationView
    private var names = ["Timmy", "John", "Kyle", "Ana", "Rachel"]
    private var ages = [17, 15, 16, 17, 16]
    private var listNumbers = [1, 2, 3, 4, 5]
    private var status = [2, 1, 1, 2, 1]
    private var images = ["Dinosaur", "hammer", "normalGopher", "Dinosaur", "Dinosaur"]
    
    private var notificationTimer = Timer()
    private var notificationImageViews: [UIImageView] = []
    private var yellowNotificationImageViews: [UIImageView] = []

    
    //temporary data for Stars
    private var starCoords: [[Int]] = [ [150, 75], [70,120], [110,300], [100, 250], [50,350] ]
    
    private var mediaView: UIView = UIView()
    private var mediaViewButtons: [UIButton] = []
    
    private var inviteButton: UIButton?
//
//    private var notificationScrollView: UIScrollView = UIScrollView()
//    private var notificationScrollViewButtons: [UIButton] = []
    
//    private var inviteFriendsView: UIView = UIView()
//    private var inviteFriendsScrollView: UIScrollView = UIScrollView()
//    private var inviteFriendsScrollViewSubviews: [UIView] = []
//    private var inviteFriendsCloseButton: UIButton = UIButton()
//    private var inviteFriendsUIButton: UIButton = UIButton()
//    private var inviteFriendsUIButtonClicked: Bool = true
//    private var inviteFriendsUIPersonalButtons: [UIButton] = []
//    private var inviteFriendsUIPersonalViews: [UIView] = []
//    private var selectedFriends: [Friend] = []

    private var stars: [Star] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFriends()
        
        setupUI()

        
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil, queue: nil) { _ in
            print("I see what you did there")
        }
    }
    
    private func setupFriends() {
        for i in 0...names.count - 1 {
            var friend = Friend(name: names[i], age: ages[i], friendListNumber: listNumbers[i], status: status[i], image: images[i], starCoords: starCoords[i])
            friends.append(friend)
        }
    }
    
    private func setupUI() {
        
        print("Width: ", view.frame.width, " Height: ", view.frame.height)
        
        setupBackground()
        
        navigationController?.navigationBar.isHidden = true
        var tabBarBounds = navigationController?.tabBarController?.tabBar.bounds
        navigationController?.tabBarController?.tabBar.backgroundImage = UIImage()
        navigationController?.tabBarController?.tabBar.shadowImage = UIImage()
        navigationController?.tabBarController?.tabBar.bounds = tabBarBounds!
        
        createStars()
                
        createNameLabel()
        
        createMediaView()
        
        initInviteButton()


    }
    
    private func setupBackground() {
        setupBackgroundAnimation()
//        setupBackgroundImage()
    }
    
    private func createNameLabel() {
        for friend in friends {
            let nameLabel = UILabel(frame: CGRect(x: friend.starCoords[0] - 30, y: friend.starCoords[0] + 30, width: 60, height: 20))
            nameLabel.textAlignment = .center
            nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
            nameLabel.alpha = 0
            nameLabels.append(nameLabel)
        }
        
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
            videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 193),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureGirlAndWaterImageView(_ imageView: UIImageView) {
        imageView.image = #imageLiteral(resourceName: "girl_and_water")

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
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureFullBackgroundImageView(_ imageView: UIImageView) {
        imageView.image = #imageLiteral(resourceName: "girl_standing_on_rock")
        imageView.layer.compositingFilter = "screenBlendMode"
    }
    
    /*
    --------------------- Star Buttons Code ---------------------
    */
    
    private func createStars() {
        for friend in friends {
            let star = Star(frame: CGRect(x: friend.starCoords[0], y: friend.starCoords[1], width: 40, height: 40))
            switch friend.status {
            case 1:
                star.setBackground(animating: true)
            case 2:
                star.setBackground(animating: false)
            default:
                print("Friend offline")
            }
            star.view.layer.compositingFilter = "screenBlendMode"
            view.addSubview(star.view)
            stars.append(star)
        }
    }
    
    private func initInviteButton() {
        inviteButton = UIButton(frame: CGRect(x: view.frame.width - 40, y: 50, width: 20, height: 20))
        guard let image = UIImage(named: "whitePlus") else { return }
        inviteButton?.setBackgroundImage(image, for: .normal)
        
        view.addSubview(inviteButton!)
    }
    
//    @objc func starHeldDown(_ gestureRecognizer: UILongPressGestureRecognizer) {
//        
//        if gestureRecognizer.state == .began {
//            
//            guard let button: UIButton? = gestureRecognizer.view as! UIButton else { return }
//            for friend in friends {
//                if friend.starButton == button {
//                    nameLabel?.text = friend.name
//                    nameLabel?.font = UIFont(name: (nameLabel?.font.fontName)!, size: 18)
//                    nameLabel?.center.x = (button?.center.x)!
//                    nameLabel?.center.y = (button?.center.y)! - 30
//                }
//            }
//            showNameLabel()
//        }
//        
//        if gestureRecognizer.state == .ended {
//            
//            hideNameLabel()
//        }
//        
//    }
    
//    private func showNameLabel() {
//        let animationDuration = 0.25
//
//        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
//            self.nameLabel?.alpha = 1
//        })
//
//    }
//
//    private func hideNameLabel() {
//        let animationDuration = 0.25
//
//        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
//            self.nameLabel?.alpha = 0
//        })
//
//    }
    
//    private func createStar(x: Int, y: Int) {
//        let starButton = UIButton(frame: CGRect(x: x, y: y, width: 60, height: 60))
//        starButton.addTarget(self, action: #selector(starButtonAction), for: .touchUpInside)
//
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.starHeldDown))
//        longPressRecognizer.minimumPressDuration = 0.5
//        starButton.addGestureRecognizer(longPressRecognizer)
//
//        currentFriend?.starButton = starButton
//        view.addSubview(starButton)
//    }
    
    
    
//    @objc func starButtonAction(sender: UIButton!) {
//      print("\nStar Clicked!\n")
//        tabBarController?.selectedIndex = 1
//
//    }
    
    
    /*
     --------------------- Bell Button Code ---------------------
    */
    
//    private func createbell(x: Int, y: Int) -> UIButton {
//        let bellButton = UIButton(frame: CGRect(x: x, y: y, width: 40, height: 40))
//        bellButton.setBackgroundImage(UIImage(named: "white_bell"), for: .normal)
//        bellButton.addTarget(self, action: #selector(bellButtonAction), for: .touchUpInside)
//
//        return bellButton
//    }
//
//    @objc func bellButtonAction(sender: UIButton!) {
//        bellClicked = !bellClicked
//
//        if bellClicked {
//            createNotificationScrollView()
//            scheduledNotificationTimerWithTimeInterval()
//        } else {
//            notificationScrollView.removeFromSuperview()
//        }
//    }
//
//    @objc func notificationButtonAction(sender: UIButton!) {
//        for i in 0...notificationScrollViewButtons.count - 1 {
//            if notificationScrollViewButtons[i] == sender {
//                print("Sending the notification to: ", friends[i].name)
//            }
//        }
//    }
//
//    func scheduledNotificationTimerWithTimeInterval(){
//        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
//        for imageView in notificationImageViews {
//            if imageView.layer.borderColor == UIColor.yellow.cgColor {
//                yellowNotificationImageViews.append(imageView)
//            }
//        }
//        notificationTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(changeImageAlpha), userInfo: nil, repeats: true)
//
//    }
//
//    @objc func changeImageAlpha(){
//        for imageView in yellowNotificationImageViews {
//            imageView.isHidden = !imageView.isHidden
//        }
//    }
//
//    private func createNotificationScrollView() {
//
//        notificationScrollView = UIScrollView(frame: CGRect(x: 60, y: 50, width: 350, height: 40))
//
//        view.addSubview(notificationScrollView)
//
//        notificationScrollView.contentSize = CGSize(width: friends.count * 50, height: 40)
//
//        notificationScrollView.backgroundColor = .clear
//        notificationScrollView.translatesAutoresizingMaskIntoConstraints = false
//
//        var friendsRed: [Friend] = []
//        var friendsYellow: [Friend] = []
//        var friendsGreen: [Friend] = []
//
//        for friend in friends {
//            switch friend.status {
//            case 0:
//                friendsRed.append(friend)
//            case 1:
//                friendsYellow.append(friend)
//            case 2:
//                friendsGreen.append(friend)
//            default:
//                print("Friend's status = ", friend.status)
//            }
//        }
//
//        friends = friendsGreen + friendsYellow + friendsRed
//        var offsetX: Int = 5
//        for friend in friends {
//            do {
//                var image = try UIImage(named: friend.image)
//                var imageView = UIImageView(frame: CGRect(x: offsetX, y: 0, width: 40, height: 40))
//                let button = UIButton(frame: imageView.frame)
//                button.backgroundColor = .clear
//
//                imageView.image = image
//                imageView.layer.masksToBounds = false
//                imageView.clipsToBounds = true
//                imageView.backgroundColor = .clear
//                imageView.layer.borderWidth = 4
//                imageView.layer.cornerRadius = imageView.frame.height/2
//
//
//
//                switch friend.status {
//                case 0:
//                    imageView.layer.borderColor = UIColor.red.cgColor
//                case 1:
//                    imageView.layer.borderColor = UIColor.yellow.cgColor
//                    button.addTarget(self, action: #selector(notificationButtonAction), for: .touchUpInside)
//                case 2:
//                    imageView.layer.borderColor = UIColor.green.cgColor
//                    button.addTarget(self, action: #selector(starButtonAction), for: .touchUpInside)
//                default:
//                    imageView.layer.borderColor = UIColor.white.cgColor
//                }
//                notificationScrollView.addSubview(imageView)
//                notificationScrollView.addSubview(button)
//                notificationScrollViewButtons.append(button)
//                notificationImageViews.append(imageView)
//
//            } catch {
//                print("Profile image not found for " + friend.name + " when the bell was pressed")
//            }
//
//            offsetX += 50
//        }
//
//    }
//
//
    
    //Side buttons
    private func createMediaView() {
        mediaView = UIStackView(frame: CGRect(x: 360, y: 350, width: 50, height: 140))
        
        view.addSubview(mediaView)
        
        mediaView.backgroundColor = UIColor(white: 0.05, alpha: 0.7)
        mediaView.layer.cornerRadius = mediaView.frame.height/10
        
        let appleMusicButton = UIButton(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        appleMusicButton.setBackgroundImage(UIImage(named: "AppleMusic"), for: .normal)
        appleMusicButton.layer.cornerRadius = appleMusicButton.frame.height/4
        appleMusicButton.layer.masksToBounds = true
        
        let netflixButton = UIButton(frame: CGRect(x: 5, y: 50, width: 40, height: 40))
        netflixButton.setBackgroundImage(UIImage(named: "Netflix"), for: .normal)
        netflixButton.layer.cornerRadius = netflixButton.frame.height/4
        netflixButton.layer.masksToBounds = true
        
        let spotifyButton = UIButton(frame: CGRect(x: 5, y: 95, width: 40, height: 40))
        spotifyButton.setBackgroundImage(UIImage(named: "Spotify"), for: .normal)
        spotifyButton.layer.cornerRadius = spotifyButton.frame.height/4
        spotifyButton.layer.masksToBounds = true
        
        mediaViewButtons = [appleMusicButton, netflixButton, spotifyButton]

        mediaView.addSubview(appleMusicButton)
        mediaView.addSubview(netflixButton)
        mediaView.addSubview(spotifyButton)

    }
    
    
    
    //Invite friends to chat
//    @objc func createInviteFriendsScrollView() {
//        inviteFriendsView = UIView(frame: CGRect(x: 220, y: 50, width: view.frame.width - 240, height: 700))
//        view.addSubview(inviteFriendsView)
//
//        inviteFriendsScrollView = UIScrollView(frame: CGRect(x: 0, y: 40, width: inviteFriendsView.frame.width, height: inviteFriendsView.frame.height - 40 - 50))
//        inviteFriendsView.addSubview(inviteFriendsScrollView)
//
//        let titleTextView = UITextView(frame: CGRect(x: 30, y: 0, width: inviteFriendsView.frame.width - 60, height: 40))
////        inviteFriendsView.addSubview(titleTextView)
//
//        let inviteFriendsButton = UIButton(frame: CGRect(x: inviteFriendsView.frame.width / 3, y: inviteFriendsView.frame.height - 45, width: inviteFriendsView.frame.width / 3, height: 40))
//        inviteFriendsView.addSubview(inviteFriendsButton)
//
//        inviteFriendsCloseButton = UIButton(frame: CGRect(x: 15, y: 20, width: 15, height: 15))
//        inviteFriendsView.addSubview(inviteFriendsCloseButton)
//
//        inviteFriendsView.backgroundColor = UIColor(white: 0.05, alpha: 0.6)
//        inviteFriendsView.backgroundColor = UIColor(white: 0.05, alpha: 0)
//        inviteFriendsView.layer.cornerRadius = mediaView.frame.height/10
//
//        titleTextView.text = "Invite Friends"
//        titleTextView.textColor = .white
//        titleTextView.backgroundColor = UIColor(white: 0.05, alpha: 0)
//        titleTextView.textAlignment = .center
//        titleTextView.font = UIFont(name: titleTextView.font!.fontName, size: 14)
//        titleTextView.isEditable = false
//
////        inviteFriendsButton.backgroundColor = UIColor(with: "#3B0087")
//        inviteFriendsButton.backgroundColor = UIColor(white: 0.05, alpha: 0.6)
//        inviteFriendsButton.setTitle("Invite", for: .normal)
//        inviteFriendsButton.setTitleColor(.white, for: .normal)
//        inviteFriendsButton.addTarget(self, action: #selector(inviteFriends), for: .touchUpInside)
//        inviteFriendsButton.layer.cornerRadius = inviteFriendsButton.frame.height/2
//
//        inviteFriendsCloseButton.setImage(UIImage(named: "close"), for: .normal)
//        inviteFriendsCloseButton.addTarget(self, action: #selector(closeInviteFriendsView), for: .touchUpInside)
//
//
//        inviteFriendsScrollView.backgroundColor = UIColor(white: 0.05, alpha: 0)
//        inviteFriendsScrollView.layer.cornerRadius = mediaView.frame.height/10
//        inviteFriendsScrollView.contentSize = CGSize(width: inviteFriendsScrollView.frame.width, height: CGFloat(friends.count * 55))
//
//
//        var offsetY = 5
//        for friend in friends {
//            let friendView = UIView(frame: CGRect(x: 10, y: offsetY, width: Int(inviteFriendsScrollView.frame.width - 20), height: 50))
//            inviteFriendsScrollView.addSubview(friendView)
//            offsetY += Int(friendView.frame.height + 10)
//
//            friendView.backgroundColor = UIColor(white: 0.05, alpha: 0.5)
//            friendView.layer.cornerRadius = friendView.frame.height/4
//
//            var image = try UIImage(named: friend.image)
//            var imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
//
//            imageView.image = image
//            imageView.layer.masksToBounds = false
//            imageView.clipsToBounds = true
//            imageView.backgroundColor = .clear
//            imageView.layer.cornerRadius = imageView.frame.height/2
//
//            var textView = UITextView(frame: CGRect(x: 50, y: 5, width: 150, height: 40))
//            textView.text = friend.name
//            textView.textAlignment = .left
//            textView.textColor = .white
//            textView.backgroundColor = .clear
//            textView.font = UIFont(name: textView.font!.fontName, size: 18)
//            textView.isEditable = false
//
//            var button = UIButton(frame: friendView.frame)
//            button.backgroundColor = .clear
//            button.addTarget(self, action: #selector(friendSelected), for: .touchUpInside)
//            inviteFriendsUIPersonalButtons.append(button)
//
//            friendView.addSubview(imageView)
//            friendView.addSubview(textView)
//            inviteFriendsScrollView.addSubview(button)
//            inviteFriendsUIPersonalViews.append(friendView)
//
//
//        }
//
//
//    }
//
//    private func createInviteFriendsUIButton() {
//        inviteFriendsUIButton = UIButton(frame: CGRect(x: view.frame.width - 60, y: 50, width: 50, height: 50))
//        inviteFriendsUIButton.setImage(UIImage(named: "ic_add"), for: .normal)
//        inviteFriendsUIButton.addTarget(self, action: #selector(createInviteFriendsScrollView), for: .touchUpInside)
//        view.addSubview(inviteFriendsUIButton)
//    }
//
//    @objc func inviteFriends() {
//        print("Inviting ", selectedFriends.count, " friends!")
//        for friend in selectedFriends {
//            print(friend.name)
//        }
//        closeInviteFriendsView()
//    }
//
//    @objc func closeInviteFriendsView() {
//        print("Closing InviteFriendsView")
//        inviteFriendsView.removeFromSuperview()
//    }
//
//    @objc func friendSelected(sender: UIButton) {
//        for i in 0...inviteFriendsUIPersonalButtons.count - 1 {
//            if sender == inviteFriendsUIPersonalButtons[i] {
//                let friend = friends[i]
//                let friendView = inviteFriendsUIPersonalViews[i]
//                if friendView.backgroundColor == UIColor(white: 0.05, alpha: 0.5) {
//                    friendView.backgroundColor = UIColor(white: 0.45, alpha: 0.5)
//                    selectedFriends.append(friend)
//                } else {
//                    friendView.backgroundColor = UIColor(white: 0.05, alpha: 0.5)
//                    for i in 0...selectedFriends.count - 1 {
//                        if selectedFriends[i].friendListNumber == friend.friendListNumber {
//                            selectedFriends.remove(at: i)
//                        }
//                    }                }
//            }
//        }
//    }
//
    
    //End of class
}

    
    
    
    
