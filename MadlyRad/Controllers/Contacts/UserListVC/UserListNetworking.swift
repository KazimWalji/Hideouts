

import UIKit
import Firebase
import FirebaseDatabase

class UserListNetworking {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var userList = [String: FriendInfo]()
    var ref = Database.database().reference()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func fetchUsers(completion: @escaping (_ userList: [String:FriendInfo]) -> Void){
        Database.database().reference().child("users").observeSingleEvent(of: .value) { (snap) in
            for child in snap.children {
                var user = FriendInfo()
                guard let snapshot = child as? DataSnapshot else { return }
                guard let values = snapshot.value as? [String: Any] else { return }
                user.email = values["email"] as? String
                user.name = values["name"] as? String
                user.UserID = values["UserID"] as? String
                user.id = snapshot.key
                if user.id != CurrentUser.uid && user.userCheck() {
                    self.userList[user.id!] = user
                }
            }
            return completion(self.userList)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
