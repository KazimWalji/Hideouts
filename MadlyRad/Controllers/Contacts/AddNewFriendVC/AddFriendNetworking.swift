

import UIKit
import Firebase
import FirebaseDatabase

protocol FriendsNetworkingViewType: class {
    func onCheckFriendship(isAddingFriend: Bool)
    func onCheckFriendRequest()
}

class AddFriendNetworking {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var friend: FriendInfo!
    //777
//    var controller: AddFriendVC!
    weak var controller: FriendsNetworkingViewType?
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func addAsFriend() {
        let ref = Database.database().reference().child("friendsList").child("friendRequests").child(friend.id ?? "").child(CurrentUser.uid).child(CurrentUser.uid)
        ref.setValue(CurrentUser.uid)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    //777 - add completion block to wait while friend will be removed
    func removeFriend(completion: @escaping(Error?)->Void) {
        let userRef = Database.database().reference().child("friendsList").child(CurrentUser.uid).child(friend.id ?? "").child(friend.id ?? "")
        let friendRef = Database.database().reference().child("friendsList").child(friend.id ?? "").child(CurrentUser.uid).child(CurrentUser.uid)
        userRef.removeValue { (error, ref) in
            friendRef.removeValue { (error, ref) in
                completion(error)
            }
        }
        Friends.contactsVC?.tableView.reloadData()
    }

    

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func checkFriend(){
        checkForFriendRequest {
            self.checkFriendship()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func removeFriendRequest() {
        Database.database().reference().child("friendsList").child("friendRequests").child(friend.id ?? "").child(CurrentUser.uid).child(CurrentUser.uid).removeValue()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func checkFriendship() {
        Database.database().reference().child("friendsList").child(CurrentUser.uid).child(friend.id ?? "").observe(.value) { [weak self] (snapshot) in
            //777
            guard let values = snapshot.value as? [String: Any] else {
                self?.controller?.onCheckFriendship(isAddingFriend: false)
                print("Friend Request sent")
                return
                
            }
            let isAddingFriend = values[self?.friend.id ?? ""] as? Bool != nil && values[self?.friend.id ?? ""] as? Bool == true
            self?.controller?.onCheckFriendship(isAddingFriend: isAddingFriend)
            //777
//            self.controller.addButton.isHidden = false
//            self.controller.loadingIndicator.stopAnimating()
//            guard let values = snapshot.value as? [String: Any] else {
//                self.controller.addButton.setTitle("Add Friend", for: .normal)
//                self.controller.addButton.layer.insertSublayer(self.controller.greenGradientLayer, at: 0)
//                self.controller.redGradientLayer.removeFromSuperlayer()
//                self.controller.grayGradientLayer.removeFromSuperlayer()
//                return
//            }
//            let f = values
//            if f[self.friend.id ?? ""] as? Bool != nil && f[self.friend.id ?? ""] as? Bool == true {
//                self.controller.greenGradientLayer.removeFromSuperlayer()
//                self.controller.grayGradientLayer.removeFromSuperlayer()
//                self.controller.addButton.layer.insertSublayer(self.controller.redGradientLayer, at: 0)
//                self.controller.addButton.setTitle("Remove Friend", for: .normal)
//            }
            //777
//            controller?.onCheckFriendship(snapshot: snapshot.value as? [String: Any])
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func checkForFriendRequest(completion: @escaping () -> Void) {
        Database.database().reference().child("friendsList").child("friendRequests").child(friend.id ?? "").child(CurrentUser.uid).observeSingleEvent(of: .value) { [weak self] (snap) in
            guard let _ = snap.value as? [String: Any] else { return completion() }
            //777
//            self.controller.addButton.setTitle("Requested", for: .normal)
//            self.controller.addButton.isHidden = false
//            self.controller.loadingIndicator.stopAnimating()
//            self.controller.redGradientLayer.removeFromSuperlayer()
//            self.controller.greenGradientLayer.removeFromSuperlayer()
//            self.controller.addButton.layer.insertSublayer(self.controller.grayGradientLayer, at: 0)
            //777
            self?.controller?.onCheckFriendRequest()
        }
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
