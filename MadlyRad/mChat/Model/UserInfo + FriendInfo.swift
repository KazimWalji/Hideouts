


import Foundation

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //
// FRIEND MODEL

struct FriendInfo {
    
    var id: String?
    
    var name: String?
    
    var profileImage: String?
    
    var email: String?
    
    var isOnline: Bool?
    
    var lastLogin: NSNumber?
    
    var UserID: String?
        
    
    func userCheck() -> Bool{
        if id == nil || name == nil || profileImage == nil, email == nil || UserID == nil{
            return false
        }
        return true
    }
    
    
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //
// USER'S FRIENDS LIST

class Friends {
    
    static var list = [FriendInfo]()
    
    static var convVC: ConversationsVC?
    
    static var contactsVC: ContactsVC?
    
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //
// USER_IS_TYPING MODEL

struct FriendActivity{
    
    let isTyping: Bool?
    
    let friendId: String?
    
    init(isTyping: Bool, friendId: String) {
        
        self.isTyping = isTyping
        self.friendId = friendId
        
    }
    
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //
