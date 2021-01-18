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
    
    private var nameLabel: UILabel?
    private var bellClicked: Bool = false
    
    private var friends: [Friend] = []
    private var currentFriend: Friend?
    
    //temporary data for NotificationView
    private var names = ["Timmy", "John", "Kyle", "Ana", "Rachel"]
    private var ages = [17, 15, 16, 17, 16]
    private var listNumbers = [1, 2, 3, 4, 5]
    private var status = [2, 1, 0, 2, 0]
    private var images = ["Dinosaur", "hammer", "normalGopher", "Dinosaur", "Dinosaur"]
    
    //temporary data for Stars
    private var starCoords: [[Int]] = [ [200, 75], [70,120], [180,230], [350, 250], [50,350] ]
    
    private var stackView: UIStackView = UIStackView()
    private var stackView2: UIStackView = UIStackView()
    
    private var scrollView: UIScrollView = UIScrollView()
    
    private var scrollViewButtons: [UIButton] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFriends()
        setupUI()
        
        friends = friends + friends
        
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
        
        setupBackground()
        
        navigationController?.navigationBar.isHidden = true
        var tabBarBounds = navigationController?.tabBarController?.tabBar.bounds
        navigationController?.tabBarController?.tabBar.backgroundImage = UIImage()
        navigationController?.tabBarController?.tabBar.shadowImage = UIImage()
        navigationController?.tabBarController?.tabBar.bounds = tabBarBounds!
        
        createStars()
        
        var bell = createbell(x: 10, y: 50)
        view.addSubview(bell)
        
        createNameLabel()

    }
    
    private func setupBackground() {
        setupBackgroundAnimation()
        setupBackgroundImage()
    }
    
    private func createNameLabel() {
        nameLabel = UILabel(frame: CGRect(x: view.frame.width/2-50, y: 50, width: 100, height: 40))
        nameLabel?.textAlignment = .center
        nameLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel?.alpha = 0
        view.addSubview(nameLabel!)
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
            videoView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 65),
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
            currentFriend = friend
            createStar(x: friend.starCoords[0], y: friend.starCoords[1])
            friends[friend.friendListNumber - 1] = currentFriend!
        }
    }
    
    @objc func starHeldDown(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            guard let button: UIButton? = gestureRecognizer.view as! UIButton else { return }
            for friend in friends {
                if friend.starButton == button {
                    nameLabel?.text = friend.name
                    nameLabel?.center.x = (button?.center.x)!
                    nameLabel?.center.y = (button?.center.y)! - 30
                }
            }
            showNameLabel()
        }
        
        if gestureRecognizer.state == .ended {
            
            hideNameLabel()
        }
        
    }
    
    private func showNameLabel() {
        let animationDuration = 0.25
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.nameLabel?.alpha = 1
        })
        
    }
    
    private func hideNameLabel() {
        let animationDuration = 0.25
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.nameLabel?.alpha = 0
        })
        
    }
    
    private func createStar(x: Int, y: Int) {
        let starButton = UIButton(frame: CGRect(x: x, y: y, width: 60, height: 60))
        starButton.addTarget(self, action: #selector(starButtonAction), for: .touchUpInside)
        createStarVideo(frame: starButton.frame)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.starHeldDown))
        longPressRecognizer.minimumPressDuration = 0.5
        starButton.addGestureRecognizer(longPressRecognizer)
        
        currentFriend?.starButton = starButton
        view.addSubview(starButton)
    }
    
    private func createStarVideo(frame: CGRect) {
        
        guard let animationPath = Bundle.main.path(forResource: "Star Animation", ofType: "mp4") else { return }
        let animationURL = URL(fileURLWithPath: animationPath)
        var videoAsset = AVAsset(url: animationURL)

        let playerItem = AVPlayerItem(asset: videoAsset)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        var starPlayerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        starPlayerLoopers.append(starPlayerLooper)
        currentFriend?.starVideoLooper = starPlayerLooper
                
        let playerLayer = AVPlayerLayer(player: queuePlayer)
        playerLayer.frame = frame
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.compositingFilter = "screenBlendMode"
        queuePlayer.play()
        
        view.layer.addSublayer(playerLayer)

    }
    
    @objc func starButtonAction(sender: UIButton!) {
      print("\nStar Clicked!\n")
        tabBarController?.selectedIndex = 1
    
    }
    
    
    /*
     --------------------- Bell Button Code ---------------------
    */
    
    private func createbell(x: Int, y: Int) -> UIButton {
        let bellButton = UIButton(frame: CGRect(x: x, y: y, width: 50, height: 50))
        bellButton.setBackgroundImage(UIImage(named: "bell icon (google)"), for: .normal)
        bellButton.addTarget(self, action: #selector(bellButtonAction), for: .touchUpInside)

        return bellButton
    }
    
    @objc func bellButtonAction(sender: UIButton!) {
        bellClicked = !bellClicked
    
        if bellClicked {
            createScrollView()
        } else {
            scrollView.removeFromSuperview()
        }
    }
    
    @objc func notificationButtonAction(sender: UIButton!) {
        for i in 0...scrollViewButtons.count - 1 {
            if scrollViewButtons[i] == sender {
                print("Sending the notification to: ", friends[i].name)
            }
        }
    }
    
    private func createScrollView() {
        
        
        
        scrollView = UIScrollView(frame: CGRect(x: 60, y: 50, width: 350, height: 40))
        
        view.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: friends.count * 50, height: 40)

        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        var friendsRed: [Friend] = []
        var friendsYellow: [Friend] = []
        var friendsGreen: [Friend] = []
        
        for friend in friends {
            switch friend.status {
            case 0:
                friendsRed.append(friend)
            case 1:
                friendsYellow.append(friend)
            case 2:
                friendsGreen.append(friend)
            default:
                print("Friend's status = ", friend.status)
            }
        }
        
        friends = friendsGreen + friendsYellow + friendsRed
        var offsetX: Int = 5
        for friend in friends {
            do {
                var image = try UIImage(named: friend.image)
                var imageView = UIImageView(frame: CGRect(x: offsetX, y: 0, width: 40, height: 40))
                let button = UIButton(frame: imageView.frame)
                button.backgroundColor = .clear
                button.addTarget(self, action: #selector(notificationButtonAction), for: .touchUpInside)
                scrollViewButtons.append(button)

                imageView.image = image
                imageView.layer.masksToBounds = false
                imageView.clipsToBounds = true
                imageView.backgroundColor = .clear
                imageView.layer.borderWidth = 4
                imageView.layer.cornerRadius = imageView.frame.height/2
                switch friend.status {
                case 0:
                    imageView.layer.borderColor = UIColor.red.cgColor
                case 1:
                    imageView.layer.borderColor = UIColor.yellow.cgColor
                case 2:
                    imageView.layer.borderColor = UIColor.green.cgColor
                default:
                    imageView.layer.borderColor = UIColor.white.cgColor
                }
                scrollView.addSubview(imageView)
                scrollView.addSubview(button)
                
            } catch {
                print("Profile image not found for " + friend.name + " when the bell was pressed")
            }
            
            offsetX += 50
        }

    }
    
    
    
    private func createStackView2() {
        
        stackView2 = UIStackView()
        view.addSubview(stackView2)
        stackView2.heightAnchor.constraint(equalToConstant: 25).isActive = true
        stackView2.widthAnchor.constraint(equalToConstant: CGFloat((friends.count * 50) + (friends.count - 1) * 10)).isActive = true
        stackView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -340).isActive = true
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.spacing = 10
        stackView2.distribution = .fillEqually
        
        var friendsRed: [Friend] = []
        var friendsYellow: [Friend] = []
        var friendsGreen: [Friend] = []
        
        for friend in friends {
            switch friend.status {
            case 0:
                friendsRed.append(friend)
            case 1:
                friendsYellow.append(friend)
            case 2:
                friendsGreen.append(friend)
            default:
                print("Friend's status = ", friend.status)
            }
        }
        
        friends = friendsGreen + friendsYellow + friendsRed

        for friend in friends {
            var textView = UITextView(frame: CGRect(x: 50, y: 50, width: 30, height: 30))
            textView.text = friend.name
            textView.backgroundColor = .clear
            textView.textAlignment = .center
            textView.layer.masksToBounds = false
            textView.clipsToBounds = true
            switch friend.status {
            case 0:
                textView.textColor = .red
            case 1:
                textView.textColor = .yellow
            case 2:
                textView.textColor = .green
            default:
                textView.textColor = .white
            }
            stackView2.addArrangedSubview(textView)
        }

    }
    
    //End of class
}

    
    
    
    
