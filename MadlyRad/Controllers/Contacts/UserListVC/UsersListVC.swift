

import UIKit
import Lottie
import FirebaseDatabase

class UsersListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    var users = [FriendInfo]()

    let userListNetworking = UserListNetworking()
    let tableView = UITableView()
    let searchbar = UISearchBar()
    let blankLoadingView = AnimationView(animation: Animation.named("blankLoadingAnim"))
    let searchController = UISearchController(searchResultsController: nil)
    
    //444
    private var cacheFriendsForSearch: [FriendInfo]?
    private var networkingLoadingIndicator = NetworkingLoadingIndicator()
    
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.hidesNavigationBarDuringPresentation = false
        self.blankLoadingView.isHidden = true
        setupTableView()
       getUsersList()
        navigationItem.titleView = searchController.searchBar
        setupBlankView(blankLoadingView)
        //background
        view.backgroundColor = .white
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = false
    
       // tableView.tableHeaderView = searchController.searchBar
        navigationController?.navigationBar.tintColor = .white
        
        
        //444
               searchController.delegate = self
               searchController.searchBar.delegate = self

      // searchdata = users
        

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
    private func getUsersList() {
        self.networkingLoadingIndicator.startLoadingAnimation()
        userListNetworking.fetchUsers { usersList in
            self.networkingLoadingIndicator.endLoadingAnimation()
            let sortedUserList = Array(usersList.values).sorted { (friend1, friend2) -> Bool in
                return friend1.name ?? "" < friend2.name ?? ""
            }
            self.users = sortedUserList
            self.blankLoadingView.isHidden = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    private func tableViewCover(){
        let tableViewC = UIView()
        view.addSubview(tableViewC)
        tableViewC.backgroundColor = .white
        let constraints = [
            tableViewC.topAnchor.constraint(equalTo: tableView.topAnchor, constant: -100),
                tableViewC.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
                tableViewC.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
                tableViewC.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            
        }
        
        
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    private func setupTableView(){
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UsersListCell.self, forCellReuseIdentifier: "UsersListCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    private func searchBar() {
            
            view.addSubview(searchbar)
            searchbar.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            let constraints = [
                searchbar.topAnchor.constraint(equalTo: view.topAnchor),
             searchbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
       
            ]
            NSLayoutConstraint.activate(constraints)

        
    }
    func dataLabel() {
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width:
        tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = "No data available"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        tableView.backgroundView  = noDataLabel
        tableView.separatorStyle  = .none
    }
//table view stuff
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(users.count)")
        if users.count > 1{
            tableView.isHidden = false
        }
        else{
            tableView.isHidden = true
        }
        /*
        if users.count > 1{
            
            
        }
        else{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
              noDataLabel.text          = "No data available"
              noDataLabel.textColor     = UIColor.black
              noDataLabel.textAlignment = .center
              tableView.backgroundView  = noDataLabel
              tableView.separatorStyle  = .none

        }
        */
        return users.count
        

    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersListCell") as! UsersListCell
        let user = users[indexPath.row]
        cell.userName.text = user.name
        cell.userEmail.text = user.UserID
        cell.backgroundColor = .clear
        

        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = AddFriendVC()
        controller.user = selectedUser
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
        
        
    }
      

    
func filterSearch(searchText: String) {
        users = cacheFriendsForSearch ?? [FriendInfo]()
    
        if searchText.isEmpty {
            tableView.reloadData()
            return
        }
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.users = self?.users.filter({
                let match = $0.UserID?.range(of: searchText)
                return match != nil
            }) ?? [FriendInfo]()
            DispatchQueue.main.async {
                let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { timer in
                    self?.tableView.reloadData()
                    print("table Reloaded")
                    self?.tableView.isHidden = false
                })
                
                self?.tableView.reloadData()
            }
        }
    }
}
extension UsersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        filterSearch(searchText: searchController.searchBar.text ?? "")
        
    }
    
}
//444
extension UsersListVC: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        cacheFriendsForSearch = users
        tableView.isHidden = false
        //getUsersList()
        

    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        users = cacheFriendsForSearch ?? [FriendInfo]()
        tableView.reloadData()
        tableView.isHidden = true
    }
    
}

