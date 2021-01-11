

import UIKit

class ProfileCell: UITableViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let profileImage = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let UserIDLabel = UILabel()
    let pronounLabel = UILabel()
    let darkBackground = UIView()
    //let changeImageButton = UIButton()
    var settingsVC: SettingsVC!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImage()
        setupNameLabel()
        setupEmailLabel()
        setupDarkBackground()
        setupUserIDLabel()
        setupPronounLabel()
        //self.setupChangeImageButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
//    private func setupChangeImageButton(){
//        self.profileImage.addSubview(self.changeImageButton)
//        let constraints = [
//            self.changeImageButton.centerYAnchor.constraint(equalTo: self.profileImage.centerYAnchor),
//            self.changeImageButton.centerXAnchor.constraint(equalTo: self.profileImage.centerXAnchor),
//            self.changeImageButton.widthAnchor.constraint(equalToConstant: self.profileImage.frame.width),
//            self.changeImageButton.heightAnchor.constraint(equalToConstant: self.profileImage.frame.height)
//        ]
//        NSLayoutConstraint.activate(constraints)
//        self.changeImageButton.setTitle("", for: .normal)
//    }
    
    private func setupImage(){
        addSubview(profileImage)
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 40
        profileImage.layer.masksToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            profileImage.heightAnchor.constraint(equalToConstant: 80),
            profileImage.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupEmailLabel(){
        addSubview(emailLabel)
        emailLabel.numberOfLines = 0
        emailLabel.adjustsFontSizeToFitWidth = true
        emailLabel.textColor = .lightGray
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            emailLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNameLabel(){
        addSubview(nameLabel)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    private func setupPronounLabel(){
        addSubview(self.pronounLabel)
        self.pronounLabel.textColor = .lightGray
        self.pronounLabel.numberOfLines = 0
        self.pronounLabel.adjustsFontSizeToFitWidth = true
        self.pronounLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.pronounLabel.topAnchor.constraint(equalTo: UserIDLabel.bottomAnchor, constant: 0),
            self.pronounLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupUserIDLabel(){
        addSubview(UserIDLabel)
        UserIDLabel.textColor = .lightGray
        UserIDLabel.numberOfLines = 0
        UserIDLabel.adjustsFontSizeToFitWidth = true
        UserIDLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            UserIDLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            UserIDLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupDarkBackground() {
        profileImage.addSubview(darkBackground)
        darkBackground.translatesAutoresizingMaskIntoConstraints = false
        darkBackground.backgroundColor = UIColor.black
        darkBackground.alpha = 0.25
        darkBackground.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeImageViewTouched))
        darkBackground.addGestureRecognizer(tap)
        let constraints = [
            darkBackground.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            darkBackground.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor),
            darkBackground.topAnchor.constraint(equalTo: profileImage.topAnchor),
            darkBackground.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        setupChangeImageView()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupChangeImageView() {
        let changeImageView = UIImageView()
        profileImage.addSubview(changeImageView)
        changeImageView.translatesAutoresizingMaskIntoConstraints = false
        changeImageView.image = UIImage(systemName: "camera.circle.fill")
        changeImageView.contentMode = .scaleAspectFill
        changeImageView.tintColor = .white
        let constraints = [
            changeImageView.centerYAnchor.constraint(equalTo: darkBackground.centerYAnchor),
            changeImageView.centerXAnchor.constraint(equalTo: darkBackground.centerXAnchor),
            changeImageView.widthAnchor.constraint(equalToConstant: 36),
            changeImageView.heightAnchor.constraint(equalToConstant: 36)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func changeImageViewTouched() {
        settingsVC.changeProfileImage()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
