

import UIKit
import FirebaseDatabase
import FirebaseAuth

var smileNotes = [String]()
var ref:DatabaseReference?
var databaseHandle:DatabaseHandle?

class SmilesNotesViewController: UIViewController, UITableViewDataSource {
  //creates table view that displays an array
    @IBOutlet weak var tableView: UITableView!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return smileNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let(note) = smileNotes [indexPath.row]
        cell.textLabel?.text = note
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        smileNotes.removeAll() //deletes old data
       
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid //user id
            //listens for added notes and appends them to table view
        databaseHandle = ref?.child("users").child(userID!).child("smileNotesReal").observe(.childAdded, with: { (snapshot) in
            let note = snapshot.value as? String
            smileNotes.append(note!)
            self.tableView.reloadData()
        })
}
}
