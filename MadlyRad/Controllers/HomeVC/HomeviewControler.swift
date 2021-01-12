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
    
    //temporary data for NotificationView
    private var names = ["Timmy", "John", "Kyle", "Ana"]
    private var ages = [17, 15, 16, 17]
    private var status = [2, 1, 0, 2]
    private var images = ["Dinosaur", "hammer", "normalGopher", "Dinosaur"]
    
//    private var girlWithWaterImageTopConstraint: NSLayoutConstraint?
//    private var girlWithWaterImageHeightConstraint: NSLayoutConstraint?
    
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
        var tabBarBounds = navigationController?.tabBarController?.tabBar.bounds
        navigationController?.tabBarController?.tabBar.backgroundImage = UIImage()
        navigationController?.tabBarController?.tabBar.shadowImage = UIImage()
        navigationController?.tabBarController?.tabBar.bounds = tabBarBounds!


//        setupInfluencersButton()
        // starsButton()
        
        var star1 = createStar(x: 100, y: 75)
        view.addSubview(star1)
        
        var bell = createbell(x: 350, y: 750)
        view.addSubview(bell)

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
        view.addSubview(imageView)
        
//        girlWithWaterImageTopConstraint = imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        
//        guard let girlWithWaterImageTopConstraint = girlWithWaterImageTopConstraint else { return }
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 105),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configureGirlAndWaterImageView(_ imageView: UIImageView) {
        imageView.image = #imageLiteral(resourceName: "girl_and_water")
        imageView.contentMode = .scaleToFill
        
        view.layoutIfNeeded()
        
//        guard let imageSize = imageView.image?.size else { return }
//        let ratio = (imageSize.height / imageSize.width)
//
//        let imageViewHieght = view.bounds.width * ratio
        
        
//        girlWithWaterImageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageViewHieght)
//        girlWithWaterImageTopConstraint?.constant = 170
//        girlWithWaterImageTopConstraint?.isActive = true
//        girlWithWaterImageHeightConstraint?.isActive = true
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
    
    
    /*
    --------------------- Star Buttons Code ---------------------
    */
    
    private func createStar(x: Int, y: Int) -> UIButton {
        let starButton = UIButton(frame: CGRect(x: x, y: y, width: 30, height: 30))
        starButton.setBackgroundImage(#imageLiteral(resourceName: "redstar"), for: .normal)
        starButton.addTarget(self, action: #selector(starButtonAction), for: .touchUpInside)
        return starButton
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
        var notifView = setupNotificationViewUI(notifView: createNotificationView())
        view.addSubview(notifView)
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
        
}

//extend the class to allow tableview to get data from HVC
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        imageView.image = UIImage(named: images[indexPath.row])
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        let nameView = UITextField(frame: CGRect(x: 70, y: 10, width: cell.frame.width - 80, height: 20))
        nameView.text = names[indexPath.row]
        nameView.font = UIFont(name: nameView.font!.fontName, size: 20)
        
        let statusView = UITextField(frame: CGRect(x: 70, y: 40, width: cell.frame.width - 80, height: 12))
        
        switch status[indexPath.row] {
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
    
    
    
    
