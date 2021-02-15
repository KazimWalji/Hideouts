
import UIKit
//666
import MessageUI
//777
import Firebase
import FirebaseDatabase

class FriendInformationVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // FriendInformationVC is shown when a user taps on the profile image located in the upper right corner in ChatVC.
    
    let calendar = Calendar(identifier: .gregorian)
    var friend: FriendInfo!
    
    let tableView = UITableView()
    let addFriendNetworking = AddFriendNetworking()
    //777
    
    //777
    let tools = ["Send Message", "Shared Media", "Report", "Block"]
    //777
    let toolsImages = ["message_icon", "image_icon", "abuse_icon", "abuse_icon"]
    //777
    private let reportSendingProblemTitle = "Send Report"
    private let reportSendingProblemMessage = "There ia a problem to send an Email. Please, check your Settings"
    //666
    private let reportRecipients = ["Hideoutsreportsystem@gmail.com"]
    private let reportSubject = "Reported user"
    lazy var reportMessage: String = {
        return "<p>Please, check up a <b>\(self.friend.id ?? "")</b> activity</p>"
    }()
    private let reportedUsersKey = "FriendInformationVC_storedReportedUserKey"
    static let blockedUsersKey = "FriendInformationVC_blockedUsersKey"
    lazy var isReported: Bool = {
        return false
        if var array = UserDefaults.standard.stringArray(forKey: self.reportedUsersKey)
        , let userID = self.friend.id {
            return array.contains(userID)
        }
        return false
    }()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Info"
        view.backgroundColor = .white
        setupTableView()
        //777
        setupNetworking()
    }
    
    //777
    private func setupNetworking() {
        addFriendNetworking.controller = self
        addFriendNetworking.friend = friend
        addFriendNetworking.checkFriend()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(FriendInformationCell.self, forCellReuseIdentifier: "friendInformationCell")
        tableView.register(FriendInformationToolsCell.self, forCellReuseIdentifier: "toolsCell")
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return tools.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendInformationCell", for: indexPath) as! FriendInformationCell
            tableView.rowHeight = 100
            cell.selectionStyle = .none
            if friend.isOnline ?? false {
                cell.onlineLabel.text = "Online"
            }else{
                let loginDate = NSDate(timeIntervalSince1970: (friend.lastLogin ?? 0).doubleValue)
                cell.onlineLabel.text = calendar.calculateLastLogin(loginDate)
            }
            cell.profileImage.loadImage(url: friend.profileImage ?? "")
            cell.nameLabel.text = friend.name
            return cell
        }else{
            tableView.rowHeight = 45
            let cell = tableView.dequeueReusableCell(withIdentifier: "toolsCell", for: indexPath) as! FriendInformationToolsCell
            let tool = tools[indexPath.row]
            let image = toolsImages[indexPath.row]
            //666
            cell.toolName.text = ((tool == "Report") && isReported ) ? "Reported" : tool
            cell.toolImage.image = UIImage(named: image)
            //666
            cell.isSelected = (tool == "Report") && isReported
            return cell
        }
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        let tool = tools[indexPath.row]
        if tool == "Send Message" {
            navigationController?.popViewController(animated: true)
        }else if tool == "Shared Media" {
            let sharedMediaVC = SharedMediaVC()
            sharedMediaVC.friend = friend
            show(sharedMediaVC, sender: self)
        }else if tool == "Report" {
            guard isReported  == false else { return }
            //777
            reportButtonPressed()
//            let reportVC = reportFriendVC()
           // addFriendNetworking.removeFriend()
            //666
            //777
//            if MFMailComposeViewController.canSendMail() {
//                let mail = MFMailComposeViewController()
//                mail.mailComposeDelegate = self
//                mail.setToRecipients(reportRecipients)
//                mail.setMessageBody(reportMessage, isHTML: true)
//                mail.setSubject(reportSubject)
//
//
//                present(mail, animated: true)
//            } else {
//                let alert = UIAlertController(title: reportSendingProblemTitle, message: reportSendingProblemMessage, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default))
//                self.present(alert, animated: true)
//            }
        } else if tool == "Block" {
            //777
            block()
//            if var array = UserDefaults.standard.stringArray(forKey: FriendInformationVC.blockedUsersKey) {
//                array.append(friend.id!)
//                UserDefaults.standard.set(array, forKey: FriendInformationVC.blockedUsersKey)
//            } else {
//                UserDefaults.standard.set([friend.id!], forKey: FriendInformationVC.blockedUsersKey)
//            }
//            addFriendNetworking.removeFriend(completion: { [weak self] _ in
//                self?.navigationController?.popToRootViewController(animated: true)
//            })
        }
    }
    
    //777
    func block() {
        if var array = UserDefaults.standard.stringArray(forKey: FriendInformationVC.blockedUsersKey) {
            array.append(friend.id!)
            UserDefaults.standard.set(array, forKey: FriendInformationVC.blockedUsersKey)
        } else {
            UserDefaults.standard.set([friend.id!], forKey: FriendInformationVC.blockedUsersKey)
        }
        addFriendNetworking.removeFriend(completion: { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        })
    }
    //666
    func markUserAsReported() {
        guard let userId = friend.id else {return }
        DispatchQueue.global().async { [weak self] in
            if let self = self {
                if var array = UserDefaults.standard.stringArray(forKey: self.reportedUsersKey)  {
                    array.append(userId)
                    UserDefaults.standard.set(array, forKey: self.reportedUsersKey)
                } else {
                    UserDefaults.standard.set([userId], forKey: self.reportedUsersKey)
                }
            }
        }
    }
    //777
    func reportButtonPressed() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.clear
        alert.addAction(UIAlertAction(title: "Spam", style: .default, handler: { [weak self] (alertAction) in
            let ref = Database.database().reference()
            guard let friendID = self?.friend.id else { return }
            self?.sendReportedEmail(reason: "Spam")
            ref.child("reported").child("spam").childByAutoId().setValue(friendID)
        }))
        alert.addAction(UIAlertAction(title: "Pornography", style: .default, handler: { [weak self] action in
            let ref = Database.database().reference()
            guard let friendID = self?.friend.id else { return }
            self?.sendReportedEmail(reason: "Pornography")
            ref.child("reported").child("explict").childByAutoId().setValue(friendID)
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    //777
    private func sendReportedEmail(reason: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(reportRecipients)
            mail.setMessageBody(reportMessage, isHTML: true)
            let subject = reportSubject.appending(" (\(reason))")
            mail.setSubject(subject)
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: reportSendingProblemTitle, message: reportSendingProblemMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
}
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    //666
extension FriendInformationVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result{
        case .sent:
            markUserAsReported()
            block()
        default:
            break
        }
        controller.dismiss(animated: true)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


//777
extension FriendInformationVC: FriendsNetworkingViewType {
    func onCheckFriendship(isAddingFriend: Bool) {
    }
    
    func onCheckFriendRequest() {
        
    }
}
