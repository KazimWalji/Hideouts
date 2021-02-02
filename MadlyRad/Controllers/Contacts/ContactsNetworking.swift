

import UIKit
import Firebase
import FirebaseDatabase

class ContactsNetworking {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var contactsVC: ContactsVC!
    
    var convoVC: ConversationsVC!
    
    var friendKeys = [String]()
    
    var groupedFriends = [String: FriendInfo]()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // Observes user's friends list
    
//    func observeFriendList() {
//        observeFriendRequests()//another func
//        Database.database().reference().child("friendsList").child(CurrentUser.uid).observeSingleEvent(of: .value) { (snap) in
//            guard let friends = snap.value as? [String: Any] else {
////                self.observeFriendActions()
//                return
//            }
//            for dict in friends.keys {
//                self.friendKeys.append(dict)
//            }
//            self.getFriendInfo()
//        }
//    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
//    private func observeFriendActions() {
//        observeNewFriend()
//        observeRemovedFriends()
//    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
//    private func observeNewFriend() {
//        Database.database().reference().child("friendsList").child(CurrentUser.uid).observe(.childAdded) { (snap) in
//            let friend = snap.key
//            self.updateFriendInfo(friend)
//            let status = self.friendKeys.contains { (key) -> Bool in
//                return friend == key
//            }
//            if status {
//                return
//            }else{
//                self.friendKeys.append(friend)
//            }
//        }
//    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
//    private func observeRemovedFriends() {
//        Database.database().reference().child("friendsList").child(CurrentUser.uid).observe(.childRemoved) { (snap) in
//            let friendToRemove = snap.key
//            var index = 0
//            for friend in Friends.list {
//                if friend.id == friendToRemove {
//                    Friends.list.remove(at: index)
//                    self.removeFriendFromArray(friendToRemove)
//                    self.contactsVC.handleEmptyList()
//                    self.contactsVC.tableView.reloadData()
//                    let friend = snap.key
//                    self.updateFriendInfo(friend)
//                    return
//                }
//                index += 1
//                self.contactsVC.tableView.reloadData()
//            }
//        }
//    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
//    private func removeFriendFromArray(_ friendToRemove: String) {
//        var index = 0
//        for friend in friendKeys {
//            if friendToRemove == friend {
//                friendKeys.remove(at: index)
//            }
//            index += 1
//        }
//        self.contactsVC.tableView.reloadData()
//    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: GET FRIEND INFO METHOD
    
    private func getFriendInfo() {
        for key in friendKeys {
            Database.database().reference().child("users").child(key).observeSingleEvent(of: .value) { (snap) in
                guard let values = snap.value as? [String: Any] else { return }
                self.setupFriendInfo(for: key, values)
                if key == self.friendKeys[self.friendKeys.count - 1] {
                    self.contactsVC.handleReload(Array(self.groupedFriends.values))
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func updateFriendInfo(_ key: String) {
        Database.database().reference().child("users").child(key).observe(.value) { (snap) in
            guard let values = snap.value as? [String: Any] else { return }
            self.setupFriendInfo(for: key, values)
            self.contactsVC.handleReload(Array(self.groupedFriends.values))
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupFriendInfo(for key: String, _ values: [String: Any]){
        var friend = FriendInfo()
        friend.id = key
       // friend.email = values["email"] as? String
        friend.profileImage = values["profileImage"] as? String
        friend.name = values["name"] as? String
        friend.isOnline = values["isOnline"] as? Bool
        friend.lastLogin = values["lastLogin"] as? NSNumber
        friend.UserID = values["UserID"] as? String
        groupedFriends[key] = friend
    }
    
    var friend = FriendInfo()
    var messageSender = Messages()
    private func namefromUID(){
        let senderID = Database.database().reference().child("messages").child(messageSender.sender)
        
        Database.database().reference().child("friendsList").child(friend.id ?? "").child(friend.name ?? "")
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func observeFriendRequests() {
        Database.database().reference().child("friendsList").child("friendRequests").child(CurrentUser.uid).observe(.value) { (snap) in
            let numOfRequests = Int(snap.childrenCount)
            //self.contactsVC.setupContactsBadge(numOfRequests)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
