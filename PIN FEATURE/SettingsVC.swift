

import UIKit
import SafariServices
//MAKE SURE TO comment out smile notes code in aboutVC once this is implemented

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let logoutButton = UIButton(type: .system)
    let tableView = UITableView()
    //add pin and smile notes to this array
    let settingsItems = ["Appearance", "Early Supports", "About", "Contact Us!", "PIN", "Smile Notes"]
    //add pics to this array, I just used question mark for now
    let settingsImages = ["paint_icon", "question-mark", "question-mark", "abuse_icon", "question-mark", "question-mark"]
    
    var settingsNetworking: SettingsNetworking!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        view.backgroundColor = .white
        settingsNetworking = SettingsNetworking(self)
        setupTableView()
        setupRightNavButton()
        view.backgroundColor = .white
   //background

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
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
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
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
        if section == 0 { return 1 } else { return 6 }  //change this number to 6
    }
    //add function below
     func smileNotesAction() {
        let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SmilesNotesViewController")
        self.present(controller, animated: false, completion: nil)
            controller.modalPresentationStyle = .fullScreen

    }

    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            tableView.rowHeight = 100
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.emailLabel.text = CurrentUser.email
            cell.nameLabel.text = CurrentUser.name
            cell.UserIDLabel.text = CurrentUser.UserID
            cell.profileImage.loadImage(url: CurrentUser.profileImage)
            cell.settingsVC = self
            return cell
        }else{
            tableView.rowHeight = 45
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
            let item = settingsItems[indexPath.row]
            let itemImg = settingsImages[indexPath.row]
            cell.settingsLabel.text = item
            cell.settingsImage.image = UIImage(named: itemImg)
            return cell
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            let controller = CurrentUserVC()
            show(controller, sender: self)
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
                //add these two if statements
                if item == "PIN"{
                    let controller = PinVC()
                    show(controller, sender: nil)
                }
                if item == "Smile Notes"{
                    smileNotesAction()
                }
            }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //

}
}
}

