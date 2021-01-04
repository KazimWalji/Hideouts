

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SettingsNetworking {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var settingsVC: SettingsVC
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ settingsVC: SettingsVC){
        self.settingsVC = settingsVC
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func logout() {
        do{
            UserActivity.observe(isOnline: false)
            try Auth.auth().signOut()
            let controller = SignInVC()
        
            Friends.list = []
            Database.database().reference().child("friendsList").child(CurrentUser.uid).removeAllObservers()
            Database.database().reference().child("users").removeAllObservers()
            Database.database().reference().child("userActions").removeAllObservers()
            settingsVC.view.window?.rootViewController = controller
            settingsVC.view.window?.makeKeyAndVisible()
        }catch{
            settingsVC.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func uploadImageToStorage(_ image: UIImage, completion: @escaping (_ imageUrl: URL?, _ error: Error?) -> Void) {
        let uniqueName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("ProfileImages").child("\(uniqueName).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.1) {
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                if let error = error { return completion(nil, error) }
                storageRef.downloadURL { (url, error) in
                    if let error = error { return completion(nil, error) }
                    if let url = url { return completion(url, nil) }
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func updateCurrentUserInfo(_ url: URL) {
        Database.database().reference().child("users").child(CurrentUser.uid).updateChildValues(["profileImage":url.absoluteString]) { (error, databaseRef) in
            guard error == nil else { return }
            self.removeOldStorageImage()
            CurrentUser.profileImage = url.absoluteString
            self.settingsVC.tableView.reloadData()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func removeOldStorageImage() {
        Storage.storage().reference(forURL: CurrentUser.profileImage).delete { (error) in
            guard error == nil else { return }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
