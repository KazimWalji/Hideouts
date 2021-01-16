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

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var playerLooper: AVPlayerLooper?
    private var starPlayerLoopers: [AVPlayerLooper] = []
    
    var conversationVC = ConversationsVC()
    var convNetwork = ConversationsNetworking()
    private var conversationBug = Converstationsbug()
    
//    private var girlWithWaterImageTopConstraint: NSLayoutConstraint?
//    private var girlWithWaterImageHeightConstraint: NSLayoutConstraint?

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
    
    
    func setupNetworking() {
        var emptyList = EmptyListView(nil, conversationVC, false)
        fetchFriendData()
        convNetwork.convVC = conversationVC
        conversationVC.emptyListView = emptyList

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        //Stops the duplications of the friends array
        if friends.count > 0 {
        } else {
            setupFriends()
        }
        
        setupUI()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNetworking()
        setupUI()
       
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil, queue: nil) { _ in
            print("I see what you did there")
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
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
    
    private func fetchFriendData() {
        
        Friends.list = []
        conversationBug.convoVC = conversationVC
        conversationBug.observeFriendList()
        conversationVC.handleReload(Friends.list)
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
            createStackView()
        } else {
            stackView.removeFromSuperview()
        }
    }

    
    private func createStackView() {
        
        stackView = UIStackView()
        view.addSubview(stackView)
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: CGFloat((friends.count * 50) + (friends.count - 1) * 10)).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -380).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        var counter = 0

        for friend in friends {
            do {
                
                var image = try UIImage(named: friend.image)
                var imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 40, height: 40))
                imageView.image = image
                //Adds gesture recognizer to each stackview item to navigate to chat of the first person
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.userAvatarTapped))
                tapGesture.delegate = self
                tapGesture.numberOfTapsRequired = 1
                imageView.addGestureRecognizer(tapGesture)
                imageView.isUserInteractionEnabled = true
                imageView.layer.masksToBounds = false
                imageView.clipsToBounds = true
                imageView.backgroundColor = .red
                imageView.layer.borderWidth = 1.5
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
                stackView.addArrangedSubview(imageView)
                counter += 1
                
                //Connects ChatVC
            
                
                
                
            } catch {
                print("Profile image not found for " + friend.name + " when the bell was pressed")
            }
        }
    }
    
    
    @objc func userAvatarTapped() {
        
        //Navigates to the first person on chat list
        let currentFriends = Friends.list
        let chat = conversationVC.messages[0]
        for usr in currentFriends {
            if usr.id == chat.determineUser() {
                let controller = ChatVC()
                controller.modalPresentationStyle = .fullScreen
                controller.friend = currentFriends[0]
                convNetwork.removeConvObservers()
                show(controller, sender: nil)
                break
            }
        }
        
    }
    
    
    //End of class
}

//extend the class to allow tableview to get data from HVC
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends.count
    }
    
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        imageView.image = UIImage(named: friends[indexPath.row].image)
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        let nameView = UITextField(frame: CGRect(x: 70, y: 10, width: cell.frame.width - 80, height: 20))
        nameView.text = friends[indexPath.row].name
        nameView.font = UIFont(name: nameView.font!.fontName, size: 20)
        
        let statusView = UITextField(frame: CGRect(x: 70, y: 40, width: cell.frame.width - 80, height: 12))
        

        
        switch friends[indexPath.row].status {
        case 0:
            statusView.text = "I will not be on for a while."
            cell.backgroundColor = .red
            break
        case 1:
            statusView.text = "I will be on in 10 minutes."
            cell.backgroundColor = .yellow
            break
        case 2:
            statusView.text = "I am online and ready to chat!"
            cell.backgroundColor = .green
            break
        default:
            statusView.text = "Error getting status"
            break;
        }
        
        statusView.font = UIFont(name: statusView.font!.fontName, size: 12)
        
        cell.addSubview(imageView)
        cell.addSubview(nameView)
        cell.addSubview(statusView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
    
    
    
    
    
    
    

    
    
 
    
