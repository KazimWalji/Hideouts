

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ToolsTB: UITableView, UITableViewDelegate, UITableViewDataSource {

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var tools = ["Reply", "Delete", "Smile Notes"]
    var toolsImg = ["arrowshape.turn.up.left", "doc.on.doc", "trash", "smile"]
    var selectedMessage: Messages!
    var scrollView: ToolsMenu!
    var selectedCell: ChatCell!
    var chatView: ChatVC!
    var smileNotes = [String]()
    var ref:DatabaseReference?
    var friend: FriendInfo!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(style: UITableView.Style, sV: ToolsMenu) {
        super.init(frame: sV.toolsView.frame, style: style)
        selectedMessage = sV.message
       // if selectedMessage.mediaUrl != nil || selectedMessage.audioUrl != nil{
  //          tools.remove(at: 2)
  //          toolsImg.remove(at: 2)
            //print("media message selected")
   //     }
        
        if selectedMessage.recipient == CurrentUser.uid{
            tools.remove(at: 1)
            toolsImg.remove(at: 1)
            print("Message selected sender")
        }
        scrollView = sV
        chatView = sV.chatVC
        selectedCell = sV.selectedCell
        delegate = self
        dataSource = self
        register(ToolsCell.self, forCellReuseIdentifier: "ToolsCell")
        separatorStyle = .singleLine
        translatesAutoresizingMaskIntoConstraints = false
        rowHeight = 50
        let toolsView = sV.toolsView
        toolsView.addSubview(self)
        let tableConstraints = [
            leadingAnchor.constraint(equalTo: toolsView.leadingAnchor, constant: -16),
            bottomAnchor.constraint(equalTo: toolsView.bottomAnchor),
            trailingAnchor.constraint(equalTo: toolsView.trailingAnchor, constant: 16),
            topAnchor.constraint(equalTo: toolsView.topAnchor),
        ]
        NSLayoutConstraint.activate(tableConstraints)
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("____", tools.count)
        return tools.count
        
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolsCell") as! ToolsCell
        print(indexPath.row)
        let tool = tools[indexPath.row]
        cell.toolName.text = tool
        cell.toolImg.image = UIImage(systemName: toolsImg[indexPath.row])
        if tool == "Delete" {
            cell.toolName.textColor = .red
            cell.toolImg.tintColor =  .red
        }else{
            cell.toolImg.tintColor = .black
            cell.toolName.textColor = .black
        }
        return cell
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tool = tools[indexPath.row]
        let repliedMesage = chatView.userResponse.repliedMessage
        tableView.deselectRow(at: indexPath, animated: true)
        if "Delete" == tool {
            removeHandler()
/*else if "Copy" == tool{
guard selectedMessage.mediaUrl == nil else { return }
let pasteBoard = UIPasteboard.general
pasteBoard.string = selectedMessage.message
scrollView.handleViewDismiss()
             }*/
        }else if "Reply" == tool{
            if repliedMesage != nil { chatView.exitResponseButtonPressed() }
            scrollView.handleViewDismiss(isReply: true)
        }else{
            let text = String()
            let ref = Database.database().reference()
                let userID = Auth.auth().currentUser?.uid
                self.ref = Database.database().reference()
                self.ref?.child("users").child(userID!).child("smileNotesReal").childByAutoId().setValue(self.selectedMessage.message)
            //print(ref.child("users").child("0MLNtujSNoZnqOZ7OEr6d4hlPQ43").child("name"))
           /* ref.child("users").observeSingleEvent(of: .value, with:{ snapshot in
                for child in snapshot.children {

                    var aasdas = self.selectedMessage.sender
                    let snap = child as! DataSnapshot
                    let nameSnap = snap.childSnapshot(forPath: aasdas!)
                    if let dict = nameSnap.value as? [String: Any]{
                    let name = dict["name"] as! String
                        print(name, "1")
                    }
                }
            })
 */
            print(self.selectedMessage.sender!)

               // self.present(alert, animated: true)
/*
         let alert = UIAlertController(title: "", message: "Add to Smile Notes?", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
                        action in
             }))
             alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
             UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
         */
            scrollView.handleViewDismiss()
        }
        
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    private func removeHandler(){
        chatView.chatNetworking.removeMessageHandler(messageToRemove: selectedMessage) {
            self.scrollView.handleViewDismiss(isDeleted: true)
        }

    }


}
