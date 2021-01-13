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
        nameLabel?.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
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
    
//    private func setupInfluencersButton() {
//        let button = UIButton(type: .system)
//        view.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setBackgroundImage(UIImage(systemName: "person.3"), for: .normal)
//
//        button.addTarget(self, action: #selector(showImagesPopup), for: .touchUpInside)
//        button.tintColor = .purple
//        self.view.addSubview(button)
//        let constraints = [
//            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            button.widthAnchor.constraint(equalToConstant: 52),
//            button.heightAnchor.constraint(equalToConstant: 32)
//        ]
//        NSLayoutConstraint.activate(constraints)
//    }
//     private var influencersPopup: InfluencersPopupViewController?
//        @objc
//        func showImagesPopup() {
//            influencersPopup = InfluencersPopupViewController()
//            guard influencersPopup != nil else { return }
//            influencersPopup!.modalPresentationStyle = .overFullScreen
//    //        influencersPopup!.onShowDetail = { [weak self] data in
//    //            let vc = InfluencerDetailViewController()
//    //            vc.data = data
//    //            self?.navigationController?.pushViewController(vc, animated: true)
//    //        }
//            self.present(influencersPopup!, animated: true, completion: nil)
//        }

    
//
//    @objc func buttonAction(sender: UIButton!) {
//      let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
//      let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeVC")
//      self.present(controller, animated: false, completion: nil);
//    }
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
    
    private func createbell(x: Int, y: Int) -> UIButton {
        let bellButton = UIButton(frame: CGRect(x: x, y: y, width: 50, height: 50))
        bellButton.setBackgroundImage(UIImage(named: "bell icon (google)"), for: .normal)
        bellButton.addTarget(self, action: #selector(bellButtonAction), for: .touchUpInside)

        return bellButton
    }
    
    @objc func bellButtonAction(sender: UIButton!) {
        print("\nBell Clicked!\n")
        bellClicked = !bellClicked
        print(bellClicked)
//        var notifView = setupNotificationViewUI(notifView: createNotificationView())
//        view.addSubview(notifView)
        if bellClicked {
            createStackView()
        } else {
            stackView.removeFromSuperview()
        }
    }
    
    private func createNotificationView() -> UIView {
        var rect = CGRect()
        let notifView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 300, height: 600)))
        notifView.center = view.center
        notifView.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        notifView.layer.cornerRadius = notifView.frame.height/30
        
        
        return notifView
    }
    
    private func setupNotificationViewUI(notifView: UIView) -> UIView {
        var titleField = UITextField(frame: CGRect(x: notifView.bounds.minX, y: notifView.bounds.minY, width: notifView.frame.width, height: 50))
        titleField.text = "Notifications"
        titleField.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        titleField.textAlignment = .center
        
        var tableView = UITableView(frame: CGRect(x: notifView.bounds.minX, y: notifView.bounds.minY + 50, width: notifView.frame.width, height: notifView.frame.height - 70))
        
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        
        notifView.addSubview(titleField)
        notifView.addSubview(tableView)
        return notifView
    }
    
    
    
    
    
    
    private func createStackView() {
        
        stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: CGFloat((friends.count * 50) + (friends.count - 1) * 10)).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -380).isActive = true
        
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fillEqually



        for friend in friends {
            do {
                var image = try UIImage(named: friend.image)
                var imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 40, height: 40))
                imageView.image = image
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
                
                
            } catch {
                print("Profile image not found for " + friend.name + " when the bell was pressed")
            }

        }
        

       
        
        
        
        
        
        
        
    }
    
    
    
    
        
}

//extend the class to allow tableview to get data from HVC
extension HomeViewController: UITableViewDataSource {
    
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
}
    
    
    
    
    
    
    

    
    
    
    
