
import UIKit
import Lottie
import FirebaseDatabase


class ContactsVC: UIViewController{
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // CONTACTS VC - USER'S FRIENDS LIST IS LOCATED HERE.
    
    let contactsNetworking = ContactsNetworking()
    let tableView = UITableView()
    let blurView = UIVisualEffectView()
    var infoMenuView: InfoMenuView!
    var tabBarBadge: UITabBarItem!
    var requestButtonView: RequestButtonView!
    let blankLoadingView = AnimationView(animation: Animation.named("blankLoadingAnim"))
    var emptyListView: EmptyListView!
    //222
   // var backgroundImageController: BackgroundImageController?
    //333
    let searchController = UISearchController(searchResultsController: nil)
    var searchButton: UIBarButtonItem?
    lazy var headerSearchView: UIView = {
        let view = UIView(frame: searchController.searchBar.frame.insetBy(dx: 0, dy: searchController.searchBar.frame.height))
   //     view.backgroundColor = UIColor(hex: "#9375e6", alpha: 0.5)
        view.addSubview(searchController.searchBar)
        searchController.searchBar.alpha = 0
        return view
    }()
    var cacheFriendsForSearch = [FriendInfo]()
    //777
    var data = [FriendInfo]()
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //777
//        setupUI()
        self.tableView.isHidden = false
        Friends.list = []
        contactsNetworking.contactsVC = self
        contactsNetworking.observeFriendList()
   //background
        view.backgroundColor = .white
        if let tabItems = tabBarController?.tabBar.items {
            tabBarBadge = tabItems[0]
        }
        
        //222
  //      backgroundImageController = BackgroundImageController(viewController: self, imageView: backgroundImage)
   //     backgroundImageController?.setupBackground()
        //333
       /// searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")
      //          , style: .plain
      //          , target: self
       //         , action: #selector(onSearchHandler))
        //searchButton!.tintColor = .white
       // navigationItem.rightBarButtonItems?.insert(searchButton!, at: 1)
      
        //searchController.searchResultsUpdater = self
       // searchController.obscuresBackgroundDuringPresentation = false
     //   self.definesPresentationContext = true
        
    //    let color = UIColor(named: "#9375e6")
      //  searchController.searchBar.barTintColor = color
      //  searchController.searchBar.backgroundColor = color
      //  searchController.searchBar.searchTextField.borderStyle = .none
      //  searchController.searchBar.searchTextField.backgroundColor = .white
     //   searchController.searchBar.searchTextField.layer.cornerRadius = 10
   //     searchController.searchBar.searchTextField.clipsToBounds = true
     //   searchController.searchBar.delegate = self
        
   //     searchController.hidesNavigationBarDuringPresentation = false
   //     searchController.searchBar.tintColor = .white
 //       searchController.searchBar.searchTextField.textColor = .black
       // UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        //777
        setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        //222
   //     backgroundImageController?.setupBackground()
        //777
        
        
        data = Friends.list
        handleEmptyList()
    }
    //222
       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
        

      //     backgroundImageController?.setupBackground()
       }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    //333
    @objc
    func onSearchHandler(_ sender: UIBarButtonItem) {
        if tableView.tableHeaderView == nil {
            cacheFriendsForSearch = Friends.list
            let frame = searchController.searchBar.frame
            tableView.tableHeaderView = headerSearchView
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.headerSearchView.frame = frame
            }
            UIView.animate(withDuration: 0.4, delay: 0.2, animations: { [weak self] in
                self?.searchController.searchBar.alpha = 1
                self?.searchController.searchBar.isHidden = false
            }) { [weak self] (flag) in
                DispatchQueue.main.async {
                    self?.searchController.searchBar.becomeFirstResponder()
                }
            }
        } else {
            Friends.list = cacheFriendsForSearch
            searchController.searchBar.endEditing(true)
            searchController.searchBar.alpha = 0
            searchController.searchBar.isHidden = true
            tableView.tableHeaderView = nil
        }
        
    }
    
    //333
    func hideSearchButton() {
        navigationItem.rightBarButtonItems?.remove(at: 1)
        searchButton = nil
    }
    
    // MARK: SETUP UI METHOD
    private func setupUI(){
        navigationItem.title = "Contacts"
        setupTableView()
        
        emptyListView = EmptyListView(self, nil , true)
        setupBlankView(blankLoadingView)
        setupaddButton()
        setupFriendRequest()
     
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ContactsCell.self, forCellReuseIdentifier: "ContactsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: HANDLE RELOAD METHOD
    
    func handleReload(_ friends: [FriendInfo]){
        Friends.list = friends
        Friends.list.sort { (friend1, friend2) -> Bool in
            return friend1.name ?? "" < friend2.name ?? ""
        }
        //777
        data = Friends.list
        handleEmptyList()
        Friends.convVC?.tableView.reloadData()
        self.tableView.reloadData()
        Friends.contactsVC?.tableView.reloadData()
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    //777
    func handleEmptyList() {
        emptyListView.isHidden = !(data.count == 0)
        
        emptyListView.emptyButton.isHidden = !(data.count == 0)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupaddButton() {
        var addButton = UIBarButtonItem()
        let buttonView = UIButton()
        buttonView.setImage(UIImage(systemName: "plus"), for: .normal)
        //buttonView.tintColor = .black
        buttonView.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton = UIBarButtonItem(customView: buttonView)
        navigationItem.rightBarButtonItem = addButton
        buttonView.tintColor = .white
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupFriendRequest() {
        requestButtonView = RequestButtonView(self)
        let requestButton = UIBarButtonItem(customView: requestButtonView)
        navigationItem.leftBarButtonItem = requestButton
        requestButton.tintColor = .white
    }
    
    // ---------------------------------------------------------------------- ------------------------------------------------------------------------------ //
    // MARK: FRIEND REQUEST HANDLER
    
    @objc func friendRequestPressed() {
        let friendRequestVC = FriendRequestVC()
        show(friendRequestVC, sender: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: ADD BUTTON HANDLER
    
    @objc func addButtonPressed(){
        let controller = UsersListVC()
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    //what the fuck
    func setupFriendInfoMenuView(_ cell: ContactsCell, cellFrame: CGRect, friend: FriendInfo){
        cell.isHidden = true
        tableView.isUserInteractionEnabled = false
        infoMenuView = InfoMenuView(cell: cell, cellFrame: cellFrame, friend: friend, contactsVC: self)
        cell.backgroundColor = .clear
        //cell.layer.borderWidth = 1.0
        
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
   func setupContactsBadge(_ numOfRequests: Int) {
        tabBarBadge.badgeValue = nil
        requestButtonView.circleView.isHidden = false
        if numOfRequests == 0 {
            requestButtonView.circleView.isHidden = true
            return
        }else if numOfRequests > 9 {
            requestButtonView.requestNumLabel.text = "+9"
        }
        
        tabBarBadge.badgeValue = "\(numOfRequests)"
        requestButtonView.requestNumLabel.text = "\(numOfRequests)"
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
}

//333
extension ContactsVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onSearchHandler(UIBarButtonItem())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterSearch(searchText:searchBar.text ?? "")
    }
    
    func filterSearch(searchText: String) {
        Friends.list = cacheFriendsForSearch
        if searchText.isEmpty {
            tableView.reloadData()
            return
        }
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
            Friends.list = Friends.list.filter({
                //444
                let match = $0.UserID?.range(of: searchText, options: .caseInsensitive)
                return match != nil
            }) ?? [FriendInfo]()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
extension ContactsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterSearch(searchText: searchController.searchBar.text ?? "")
    }
    
}




extension ContactsVC: UITableViewDataSource, UITableViewDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //777
   //    return Friends.list.count
        if data.count > 0{
            tableView.isHidden = false
            print(data.count)
        }
        return data.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    //what the fuck
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell") as! ContactsCell
        cell.selectionStyle = .none
        //777
//        let friend = Friends.list[indexPath.row]
        
        
        cell.backgroundColor = .clear
        let friend = data[indexPath.row]
        cell.profileImage.loadImage(url: friend.profileImage ?? "")
        cell.friendName.text = friend.name
        cell.isOnlineView.isHidden = !(friend.isOnline ?? false)
        cell.UserID.text = friend.UserID
        
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //777
        //let friend = Friends.list[indexPath.row]
        
        let friend = data[indexPath.row]
        
        if let cellFrame = tableView.cellForRow(at: indexPath)?.frame, let cell = tableView.cellForRow(at: indexPath){
            let convertedFrame = tableView.convert(cellFrame, to: tableView.superview)
            setupFriendInfoMenuView(cell as! ContactsCell, cellFrame: convertedFrame, friend: friend)
        }
     
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
