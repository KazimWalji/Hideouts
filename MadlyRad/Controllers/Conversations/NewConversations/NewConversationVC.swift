

import UIKit
import Firebase

class NewConversationVC: UIViewController {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let tableView = UITableView()
    var forwardDelegate: ChatVC!
    var conversationDelegate: ConversationsVC!
    var forwardName: String?
    
    private var friends = [FriendInfo]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friends = [FriendInfo(id: nil, name: "Name", profileImage: nil, email: "test@test.com", isOnline: nil, lastLogin: nil, UserID: nil)]

        setupForwardView()
        navigationController?.navigationBar.tintColor = .black
        setupTableView()
        
        //let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    //    backgroundImage.image = UIImage(named: "backgroundimageforhideouts.png")
    //     backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
    //    self.view.insertSubview(backgroundImage, at: 0)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupForwardView(){
        navigationItem.title = forwardName != nil ? "Forward" : "New Conversation"
        let leftButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func cancelButtonPressed(){
        forwardDelegate?.userResponse.messageToForward = nil
        forwardDelegate?.userResponse.messageSender = nil
        dismiss(animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(NewConversationCell.self, forCellReuseIdentifier: "NewConversationCell")

        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

extension NewConversationVC: UITableViewDelegate, UITableViewDataSource {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewConversationCell") as! NewConversationCell
        cell.selectionStyle = .none
        let friend = friends[indexPath.row]
        
        if let profileImageURL = friend.profileImage {
            cell.profileImage.loadImage(url: friend.profileImage ?? "")
        } else {
            //TODO: implement default image
        }
        cell.friendName.text = friend.name
        cell.friendEmail.text = friend.email
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        if let name = forwardName {
            //forwardDelegate?.forwardToSelectedFriend(friend: friend, for: name)
            dismiss(animated: true, completion: nil)
            return
        }
        conversationDelegate.showSelectedUser(selectedFriend: friend)
        dismiss(animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //

}
