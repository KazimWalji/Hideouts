

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseMessaging

class AuthNetworking {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var mainController: UIViewController!
    var ref = Storage.storage()
    var networkingLoadingIndicator = NetworkingLoadingIndicator()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ mainController: UIViewController?){
        self.mainController = mainController
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: SIGN IN METHOD
    
    func signIn(with email: String, and pass: String, completion: @escaping (_ error: Error?) -> Void){
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
            if let error = error {
                self.networkingLoadingIndicator.endLoadingAnimation()
                return completion(error)
            }else{
                self.nextController()
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    //
    private func nextController(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        setupUserInfo(uid) { (isActive) in
            if isActive{
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "HomeVC", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DatePicker") as! DatePicker
                nextViewController.modalPresentationStyle = .fullScreen
           //     let controller = WelcomeVC()
                //controller.modalPresentationStyle = .fullScreen
                self.mainController.present(nextViewController, animated: false, completion: nil)
                self.networkingLoadingIndicator.endLoadingAnimation()
            }
        }
        
    }


    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: SETUP USER INFO METHOD
    
    func setupUserInfo(_ uid: String, completion: @escaping (_ isActive: Bool) -> Void) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let snap = snapshot.value as? [String: AnyObject] else { return }
            CurrentUser.name = snap["name"] as? String
            CurrentUser.email = snap["email"] as? String
            CurrentUser.profileImage = snap["profileImage"] as? String
            CurrentUser.uid = uid
            CurrentUser.UserID = snap["UserID"] as? String
            CurrentUser.pronoun = snap["pronoun"] as? String
           
        if let token = Messaging.messaging().fcmToken { Database.database().reference().child("users").child(CurrentUser.uid).updateChildValues(["registration_token": token])
             CurrentUser.registration_token = token
            }
            UserActivity.observe(isOnline: true)
            if CurrentUser.uid == nil || CurrentUser.profileImage == nil || CurrentUser.name == nil{
                do{
                    try Auth.auth().signOut()
                    return completion(false)
                }catch{
                    
                }
            }
            return completion(true)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func checkForExistingEmail(_ email: String, completion: @escaping (_ errorMessage: String?) -> Void) {
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            self.networkingLoadingIndicator.endLoadingAnimation()
            if methods == nil {
                return completion(nil)
            }else{
                return completion("This email is already in use.")
            }
        }
    }
    func checkForExistingUserID(with UserID: String, completion: @escaping (_ errorMessage: String?)-> Void) {
        Database.database().reference().child("users").queryOrdered(byChild: "UserID").queryEqual(toValue: UserID).observeSingleEvent(of: .value) { (sanpshot) in
            if sanpshot.exists() == true {
                return completion("This UserID is already in use.")
            }else{
                return completion(nil)
            }
            //sanpshot.exists() // it will return true or false
        }
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: SIGN UP USER METHOD
    
    func registerUser(_ name: String, _ email: String, _ password: String, _ profileImage: UIImage?, _ UserID: String,_ pronoun:String, completion: @escaping (_ error: String?) -> Void) {
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if let error = error { return completion(error.localizedDescription) }
            guard let uid = dataResult?.user.uid else { return completion("Error occured, try again!") }
            let imageToSend = profileImage ?? UIImage(named: "DefaultUserImage")
            self.uploadProfileImageToStorage(imageToSend!) { (url, error) in
                if let error = error { return completion(error.localizedDescription) }
                guard let url = url else { return }
                let values: [String: Any] = ["name": name, "email": email, "profileImage": url.absoluteString, "UserID": UserID,"pronoun":pronoun]
                self.registerUserHandler(uid, values) { (error) in
                    if let error = error { return completion(error.localizedDescription) }
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func registerUserHandler(_ uid: String, _ values: [String:Any], completion: @escaping (_ error: Error?) -> Void) {
        let usersRef = Database.database().reference().child("users").child(uid)
        usersRef.updateChildValues(values) { (error, dataRef) in
            if let error = error { return completion(error) }
            self.nextController()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: UPLOAD IMAGE METHOD
    
    private func uploadProfileImageToStorage(_ image: UIImage, completion: @escaping (_ imageUrl: URL?, _ error: Error?) -> Void) {
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
}
