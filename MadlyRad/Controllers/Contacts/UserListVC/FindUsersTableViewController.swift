//
//  FindUsersTableViewController.swift
//  MadlyRad
//
//  Created by JOJO on 8/30/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FindUsersTableViewController: UITableViewController, UISearchResultsUpdating {
    var friend = FriendInfo()
    var userss = [FriendInfo]()
    @IBOutlet var FindUsersTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var usersArray = [NSDictionary?]()
    var filterdUsers = [NSDictionary?]()
   var databaseRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        databaseRef.child("users").queryOrdered(byChild: "UserID").observe(.childAdded, with:  {(snapshot) in
            
            self.usersArray.append(snapshot.value as? NSDictionary)
            self.FindUsersTableView.insertRows(at: [IndexPath(row:self.usersArray.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         
        if searchController.isActive && searchController.searchBar.text != ""{
            return filterdUsers.count
        }
        return self.usersArray.count
       
    }
 /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedUser = filterdUsers[indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
        let controller = AddFriendVC()
        controller.user = selectedUser
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
   */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersList", for: indexPath) //as! UsersListCell
        let user : NSDictionary?
        cell.contentView.isHidden = true
        if searchController.isActive && searchController.searchBar.text != ""{
            user = filterdUsers[indexPath.row]
            cell.contentView.isHidden = false
        }else{
            user = self.usersArray[indexPath.row]
        }
        cell.textLabel?.text = user?["UserID"] as? String


        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func updateSearchResults(for searchController: UISearchController){
        filteredContent(searchText: self.searchController.searchBar.text!)
    }
    func filteredContent(searchText:String) {
        self.filterdUsers = self.usersArray.filter{ user in
            let username = user?["UserID"] as? String
    
            return (username?.lowercased().contains(searchText.lowercased()) ?? false)
        
        }
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { timer in
            self.tableView.reloadData()
            print("table Reloaded")
            self.tableView.isHidden = false
        })
        
    }

}
