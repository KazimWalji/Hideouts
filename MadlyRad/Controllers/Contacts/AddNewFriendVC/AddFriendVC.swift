

import UIKit
import Firebase
import FirebaseDatabase



class AddFriendVC: UIViewController{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    static let blockedUsersKey = "FriendInformationVC_blockedUsersKey"

    var user: FriendInfo!
    var addButton: UIButton!
    let addFriendNetworking = AddFriendNetworking()
    var loadingIndicator: UIActivityIndicatorView!
    var greenGradientLayer: CALayer!
    var redGradientLayer: CALayer!
    var grayGradientLayer: CALayer!
    var ref: DatabaseReference?
    var friend: FriendInfo!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNetworking()
        //reportButton()
        view.backgroundColor = .white
        //background
        blockedButton()
        addButton.setTitle("Add Friend", for: .normal)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNetworking() {
        addFriendNetworking.controller = self
        addFriendNetworking.friend = user
        addFriendNetworking.checkFriend()
        }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUI(){
        navigationController?.navigationBar.tintColor = .black
       // view.backgroundColor = .white
        handleButtonGradient()
        //setupGradientView()
       setupExitButton()
        setupUserInfoView()
        reportButton()
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func handleButtonGradient() {
        for g in ["red","green","gray"] {
            let gradient = setupButtonGradientLayer(g)
            if g == "red"{
                redGradientLayer = gradient
            }else if g == "green"{
                greenGradientLayer = gradient
            }else{
                grayGradientLayer = gradient
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupButtonGradientLayer(_ color: String) -> CALayer {
        let gradient = CAGradientLayer()
        var firstColor: CGColor!
        var secondColor: CGColor!
        if color == "green" {
            firstColor = UIColor(red: 100/255, green: 200/255, blue: 110/255, alpha: 1).cgColor
            secondColor = UIColor(red: 150/255, green: 210/255, blue: 130/255, alpha: 1).cgColor
        }else if color == "red"{
            firstColor = UIColor(red: 235/255, green: 155/255, blue: 125/255, alpha: 1).cgColor
            secondColor = UIColor(red: 230/255, green: 80/255, blue: 70/255, alpha: 1).cgColor
        }else{
            firstColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
            secondColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        }
        gradient.colors = [firstColor!, secondColor!]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.locations = [0, 1]
        gradient.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        return gradient
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupGradientView() {
        let _ = GradientLogoView(self, true)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUserInfoView(){
        let infoView = UserInfoView(self)
        addButton = infoView.addButton
        
        loadingIndicator = infoView.loadingIndicator
    }
    private func reportButton(){
        let button = UIButton(frame: CGRect(x: self.view.center.x, y: 600, width: 325, height: 50))
        button.center.x = self.view.center.x
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
          button.setTitle("Report User", for: .normal)
          button.addTarget(self, action: #selector(reportButtonPressed), for: .touchUpInside)

          self.view.addSubview(button)

        }

    @objc func reportButtonPressed() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.clear
        alert.addAction(UIAlertAction(title: "Spam", style: .default, handler: { (alertAction) in
                  self.ref = Database.database().reference()
            self.ref?.child("reported").child("spam").childByAutoId().setValue(self.user.email)
        }))
        alert.addAction(UIAlertAction(title: "Explicit Content", style: .default, handler: { action in
            self.ref = Database.database().reference()
            self.ref?.child("reported").child("explict").childByAutoId().setValue(self.user.email)
        }))

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

        }


    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    private func blockedButton(){
    let button = UIButton(frame: CGRect(x: self.view.center.x, y: 570, width: 325, height: 50))
    button.center.x = self.view.center.x
    button.setTitleColor(UIColor.black, for: UIControl.State.normal)
      button.setTitle("Block", for: .normal)
      button.addTarget(self, action: #selector(blockedButtonpressed), for: .touchUpInside)

      self.view.addSubview(button)

    }
    @objc func blockedButtonpressed() {
        print("hi")
             if var array = UserDefaults.standard.stringArray(forKey: FriendInformationVC.blockedUsersKey) {
                 array.append(self.user.UserID!)
                 UserDefaults.standard.set(array, forKey: FriendInformationVC.blockedUsersKey)
             } else {
                UserDefaults.standard.set([self.user.UserID!], forKey: FriendInformationVC.blockedUsersKey)
             }
        addFriendNetworking.removeFriend(completion: { [weak self] _ in
         
             self?.navigationController?.popToRootViewController(animated: true)
        
        })

    }


    private func setupExitButton() {
        let exitButton = UIButton(type: .system)
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setBackgroundImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        exitButton.tintColor = ThemeColors.mainColor
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        let constraints = [
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            exitButton.widthAnchor.constraint(equalToConstant: 32),
            exitButton.heightAnchor.constraint(equalToConstant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // -----------------------------------------------------------------------------------------------------------------------------------x----------------- //s
    
    @objc private func exitButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func addButtonPressed() {
        if addButton.titleLabel?.text == "Add Friend" {
            addButton.setTitle("Requested", for: .normal)
            addButton.layer.insertSublayer(grayGradientLayer, at: 0)
            redGradientLayer.removeFromSuperlayer()
            greenGradientLayer.removeFromSuperlayer()
        } else {
            addFriendNetworking.removeFriendRequest()
            addFriendNetworking.removeFriend(completion: {_ in})
            addButton.layer.insertSublayer(greenGradientLayer, at: 0)
            redGradientLayer.removeFromSuperlayer()
            grayGradientLayer.removeFromSuperlayer()
            addButton.setTitle("Add Friend", for: .normal)
            return
        }
        addFriendNetworking.addAsFriend()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //


}

extension AddFriendVC: FriendsNetworkingViewType {
    
    func onCheckFriendship(isAddingFriend: Bool) {
        self.addButton.isHidden = false
        self.loadingIndicator.stopAnimating()
        if isAddingFriend == false{
            self.addButton.setTitle("Add Friend", for: .normal)
            self.addButton.layer.insertSublayer(self.greenGradientLayer, at: 0)
            self.redGradientLayer.removeFromSuperlayer()
            self.grayGradientLayer.removeFromSuperlayer()
           // self.loadingIndicator.stopAnimating()

        } else {
            
            self.greenGradientLayer.removeFromSuperlayer()
            self.grayGradientLayer.removeFromSuperlayer()
            self.addButton.layer.insertSublayer(self.redGradientLayer, at: 0)
            self.addButton.setTitle("Remove Friend", for: .normal)
            //self.loadingIndicator.stopAnimating()

        }
    }
    
    func onCheckFriendRequest() {
        self.addButton.setTitle("Requested", for: .normal)
        self.addButton.isHidden = false
        self.loadingIndicator.stopAnimating()
        self.redGradientLayer.removeFromSuperlayer()
        self.greenGradientLayer.removeFromSuperlayer()
        self.addButton.layer.insertSublayer(self.grayGradientLayer, at: 0)
    }
}

