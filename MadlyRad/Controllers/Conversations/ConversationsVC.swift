

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
        Friends.list = []
        conversationBug.convoVC = self
        conversationBug.observeFriendList()
        loadConversations()
        setupNewConversationButton()
        //        contactsButton()
        setupTableView()
        emptyListView = EmptyListView(nil, self, false) //false for conversation view and true for contacts view
        setupBlankView(blankLoadingView) //skeleton view
        Friends.convVC = self
        
        
        ConversationsNetworking()
        
        //tableView.backgroundColor = .white
        //background
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        if let tabItems = tabBarController?.tabBar.items {
            tabBarBadge = tabItems[1]
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        //222
        // backgroundImageController?.setupBackground()
        //777
        Friends.list = []
        conversationBug.convoVC = self
        conversationBug.observeFriendList()
        
        
        self.loadConversations()
        
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
    }
    
    //222
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //    backgroundImageController?.setupBackground()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //

    
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: LOAD CONVERSATIONS METHOD
    
    private func loadConversations() {
        convNetworking.convVC = self
        convNetworking.observeFriendsList()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func loadMessagesHandler(_ newMessages: [Messages]?) {
        blankLoadingView.isHidden = true
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
    
    func nextControllerHandler(usr: FriendInfo) {
        let controller = ChatVC()
        controller.modalPresentationStyle = .fullScreen
        controller.friend = usr
        convNetworking.removeConvObservers()
        show(controller, sender: nil)
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
        self.contactsVC.tableView.reloadData()
        self.tableView.reloadData()
    }
    func handleEmptyList() {
        emptyListView.isHidden = !(Friends.list.count == 0)
        emptyListView.emptyButton.isHidden = !(Friends.list.count == 0)
    }
    
    
}
