

import UIKit
import Firebase

extension ConversationsVC: UITableViewDelegate, UITableViewDataSource {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
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
        let recent = messages[indexPath.row]
        cell.convVC = self
        cell.message = recent
        cell.unreadMessageView.isHidden = true
        cell.backgroundColor = .clear
        convNetworking.observeUnreadMessages(recent.determineUser()) { (unreadMessage) in
            if let numOfMessages = unreadMessage[cell.message!.determineUser()], numOfMessages > 0 {
                cell.unreadMessageView.isHidden = false
                cell.unreadLabel.text = "\(numOfMessages)"
                cell.backgroundColor = .clear
            }else{
                cell.unreadMessageView.isHidden = true
                cell.backgroundColor = .clear
            }
        }
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = messages[indexPath.row]
        for usr in Friends.list {
            if usr.id == chat.determineUser() {
                nextControllerHandler(usr: usr)
                break
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

