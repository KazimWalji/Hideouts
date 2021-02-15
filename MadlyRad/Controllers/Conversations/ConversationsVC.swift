

import UIKit
import Lottie

class ConversationsVC: UIViewController {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // ConversationVC is responsible for showing recent messages from user's friends and their actions. (If user and his/her friend haven't had a conversation, then friend's cell in tableView won't be visible.
    
    let convNetworking = ConversationsNetworking()
    var messages = [Messages]()
    var contactsVC = ContactsVC()
    
    let tableView = UITableView()
    let calendar = Calendar(identifier: .gregorian)
    var newConversationButton = UIBarButtonItem()
    var tabBarBadge: UITabBarItem!
    let blankLoadingView = AnimationView(animation: Animation.named("blankLoadingAnim"))
    
    var emptyListView: EmptyListView! //view with button, when no item to show
    var contactNavigation = UIBarButtonItem()
    var groupedMessages = [String: Messages]()
    var unreadMessages = [String: Int]()
    var friendKeys = [String]()
    var totalUnread = Int()
    var conversationBug = Converstationsbug()
    let contactsNetworking = ContactsNetworking()
    //var backgroundImageController: BackgroundImageController?
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"

        loadConversations()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        //        loadConversations()
        //    setupUI()
        //222
        // backgroundImageController?.setupBackground()
        //777
        Friends.list = []
//        conversationBug.convoVC = self
//        conversationBug.observeFriendList()
        DispatchQueue.main.async { [weak self] in
            self?.loadConversations()
            self?.setupUI()
        }
        //         loadConversations()
        //         setupUI()
        //         ConversationsNetworking()
        
        //tableView.backgroundColor = .white
        // let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        // backgroundImage.image = UIImage(named: "backgroundimageforhideouts.png")
        // backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        // self.view.insertSubview(backgroundImage, at: 0)
        if let tabItems = tabBarController?.tabBar.items {
            tabBarBadge = tabItems[1]
        }
        //222
        //   backgroundImageController = BackgroundImageController(viewController: self, imageView: backgroundImage)
        //     backgroundImageController?.setupBackground()
        tableView.reloadData()
        
        blankLoadingView.isHidden = true
    }
    
    //222
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //    backgroundImageController?.setupBackground()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUI(){
        view.backgroundColor = .white
        setupNewConversationButton()
        //        contactsButton()
        setupTableView()
        emptyListView = EmptyListView(nil, self, false)
        setupBlankView(blankLoadingView)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.register(ConversationsCell.self, forCellReuseIdentifier: "ConversationsCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNewConversationButton() {
        newConversationButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(newConversationTapped))
        newConversationButton.tintColor = .white
        navigationItem.rightBarButtonItem = newConversationButton
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    //  private func contactsButton() {
    //      contactNavigation = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(contactsButtonTapped))
    //     contactNavigation.tintColor = .black
    //    navigationItem.leftBarButtonItem = contactNavigation
    
    
    // }
    @objc func newConversationTapped() {
        let controller = NewConversationVC()
        controller.conversationDelegate = self
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    @objc func contactsButtonTapped() {
        let controller = ContactsVC()
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    private func loadConversations() {
        let recent = Messages()
        recent.message = "Hi"
        recent.sender = "Sender"
        recent.time = NSNumber()
        recent.id = UUID().uuidString
        recent.imageWidth = NSNumber(floatLiteral: 100)
        recent.imageHeight = NSNumber(floatLiteral: 100)
        messages = [recent]
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func loadMessagesHandler(_ newMessages: [Messages]?) {
        if let newMessages = newMessages {
            handleReload(newMessages)
        }
        observeMessageActions()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: HANDLE RELOAD
    
    private func handleReload(_ newMessages: [Messages]) {
        messages = newMessages
        if messages.count != 0 {
            emptyListView.isHidden = true
            emptyListView.emptyButton.isHidden = true
        }
        messages.sort { (message1, message2) -> Bool in
            return message1.time.intValue > message2.time.intValue
        }
        tableView.reloadData()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: MESSAGE ACTIONS.
    
    func observeMessageActions() {
        convNetworking.observeDeletedMessages()
        convNetworking.observeNewMessages { (newMessages) in
            self.handleReload(newMessages)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func observeIsUserTypingHandler(_ recent: Messages, _ cell: ConversationsCell){
        convNetworking.observeIsUserTyping(recent.determineUser()) { (isTyping, friendId) in
            if isTyping && cell.message?.determineUser() == friendId {
                cell.recentMessage.isHidden = true
                cell.timeLabel.isHidden = true
                cell.isTypingView.isHidden = false
                cell.checkmark.isHidden = true
                cell.backgroundColor = .clear
            }else{
                self.setupNoTypingCell(cell)
                if cell.message?.sender == CurrentUser.uid{
                    cell.checkmark.isHidden = false
                    cell.backgroundColor = .clear
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func observeIsUserSeenMessage(_ recent: Messages, _ cell: ConversationsCell) {
        guard let id = cell.message?.determineUser() else { return }
        convNetworking.observeUserSeenMessage(id) { (num) in
            if num == 0 {
                cell.checkmark.image = UIImage(named: "doubleCheckmark_icon")
                cell.backgroundColor = .clear
            }else{
                cell.checkmark.image = UIImage(named: "checkmark_icon")
                cell.backgroundColor = .clear
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func handleReload(_ friends: [FriendInfo]){
        Friends.list = friends
        Friends.list.sort { (friend1, friend2) -> Bool in
            return friend1.name ?? "" < friend2.name ?? ""
        }
        handleEmptyList()
        self.tableView.reloadData()
    }
    func handleEmptyList() {
        emptyListView.isHidden = !(Friends.list.count == 0)
        emptyListView.emptyButton.isHidden = !(Friends.list.count == 0)
    }
}

extension ConversationsVC: UITableViewDelegate, UITableViewDataSource {
        
    func setupNoTypingCell(_ cell: ConversationsCell){
        cell.isTypingView.isHidden = true
        cell.recentMessage.isHidden = false
        cell.timeLabel.isHidden = false
        cell.backgroundColor = .clear
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsCell") as! ConversationsCell
        cell.selectionStyle = .none
        let recent = messages.first!
        cell.convVC = self
        cell.message = recent
        cell.unreadMessageView.isHidden = true
        cell.backgroundColor = .clear
//        convNetworking.observeUnreadMessages(recent.determineUser()) { (unreadMessage) in
//            if let numOfMessages = unreadMessage[cell.message!.determineUser()], numOfMessages > 0 {
//                cell.unreadMessageView.isHidden = false
//                cell.unreadLabel.text = "\(numOfMessages)"
//                cell.backgroundColor = .clear
//            }else{
//                cell.unreadMessageView.isHidden = true
//                cell.backgroundColor = .clear
//            }
//        }
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = messages[indexPath.row]
        for usr in Friends.list {
            if usr.id == chat.determineUser() {
                let chatVC = ChatVC()
                
                break
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
