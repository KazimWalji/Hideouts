

import UIKit
import SafariServices

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let logoutButton = UIButton(type: .system)
    let tableView = UITableView()
    
    let settingsItems = ["Appearance", "Early Supports", "About", "Contact Us!", "Background Image","Share BestFriends with friends"]
    let settingsImages = ["paint_icon", "question-mark", "question-mark", "abuse_icon", "backgroundIcon","share1"]
    
    var settingsNetworking: SettingsNetworking!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        
        view.backgroundColor = .white
        let background = UIImageView(frame: view.frame)
        background.bounds = view.bounds
        background.image = #imageLiteral(resourceName: "purpleBackground")
        view.addSubview(background)
        settingsNetworking = SettingsNetworking(self)
        setupTableView()
        setupRightNavButton()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barTintColor = .clear
        tabBarController?.tabBar.isHidden = false

    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupRightNavButton(){
        logoutButton.setTitle("Sign out", for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "Proxima Nova", size: 18)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.addTarget(self, action: #selector(setupLogoutView), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func setupLogoutView() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Exit", style: .destructive) { (true) in
            self.logoutButtonPressed()
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(exitAction)
        present(alert, animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func logoutButtonPressed(){
        settingsNetworking.logout()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func changeProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Open Photo Library", style: .default, handler: { (alertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        settingsNetworking.uploadImageToStorage(originalImage) { (url, error) in
            guard error == nil , let url = url else { return }
            self.settingsNetworking.updateCurrentUserInfo(url)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
        
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 { return 30 } else { return 0.1 }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 } else { return 6 }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            tableView.rowHeight = 100
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.emailLabel.text = CurrentUser.email
            cell.nameLabel.text = CurrentUser.name
            cell.UserIDLabel.text = CurrentUser.UserID
            cell.pronounLabel.text = CurrentUser.pronoun
            cell.profileImage.loadImage(url: CurrentUser.profileImage)
            cell.settingsVC = self
            cell.backgroundColor = .clear
            return cell
        }else{
            tableView.rowHeight = 45
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
            let item = settingsItems[indexPath.row]
            let itemImg = settingsImages[indexPath.row]
            cell.settingsLabel.text = item
            cell.settingsLabel.textColor = .white
            cell.settingsImage.image = UIImage(named: itemImg)
            cell.backgroundColor = UIColor(white: 0.05, alpha: 0.3)
            return cell
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            self.changeProfileImage()
        }else{ //if indexPath.section == 1
            let item = settingsItems[indexPath.row]
            if item == "Appearance"{
                let controller = AppearanceVC()
                show(controller, sender: nil)
            }else{ //if indexPath.section == 2
                let item = settingsItems[indexPath.row]
                if item == "About"{
                    let controller = AboutViewController()
                    show(controller, sender: nil)
                }
                if item == "Contact Us!"{
                    if let url = URL(string: "https://hideoutsusa.com/contact/"){
                    let safariVC = SFSafariViewController(url: url)
                        self.present(safariVC, animated: true, completion: nil)

                    }
                }
                if item == "Share BestFriends with friends"{
                        
                        // Setting description
                            let firstActivityItem = "Check out this app!"

                            // Setting url
                            let secondActivityItem : NSURL = NSURL(string: "https://apps.apple.com/tr/app/hideouts/id1525274348")!

                            // If you want to use an image
                            let image : UIImage = UIImage(named: "AppIcon")!
                 
                            let activityViewController : UIActivityViewController = UIActivityViewController(
                                activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)

                            // This lines is for the popover you need to show in iPad
                        activityViewController.popoverPresentationController?.sourceView = self.view

                            // This line remove the arrow of the popover to show in iPad
                            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

                            // Pre-configuring activity items
                            activityViewController.activityItemsConfiguration = [
                            UIActivity.ActivityType.message
                            ] as? UIActivityItemsConfigurationReading

                            // Anything you want to exclude
                            activityViewController.excludedActivityTypes = [
                                UIActivity.ActivityType.postToWeibo,
                                UIActivity.ActivityType.print,
                                UIActivity.ActivityType.assignToContact,
                                UIActivity.ActivityType.saveToCameraRoll,
                                UIActivity.ActivityType.addToReadingList,
                                UIActivity.ActivityType.postToFlickr,
                                UIActivity.ActivityType.postToVimeo,
                                UIActivity.ActivityType.postToTencentWeibo,
                                UIActivity.ActivityType.postToFacebook
                            ]

                            activityViewController.isModalInPresentation = true
                            self.present(activityViewController, animated: true, completion: nil)
                        
                    }
                
                if item == "Background Image" {
                    let controller = ChangeBackgroundVC()
                    show(controller, sender: nil)
                }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //

}
}
}

