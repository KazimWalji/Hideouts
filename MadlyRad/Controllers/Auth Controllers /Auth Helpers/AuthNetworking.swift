

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseMessaging
import FirebaseFirestore

class AuthNetworking {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var mainController: UIViewController!
    var ref = Storage.storage()
    // TODO: remove UI from network layer
    var networkingLoadingIndicator = NetworkingLoadingIndicator()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ mainController: UIViewController?) {
        // TODO: refactor to not refer to the view controller layer
        self.mainController = mainController
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: SIGN IN METHOD
    
    func signIn(with email: String, and pass: String, completion: @escaping (_ error: Error?) -> Void){
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
            if let error = error {
                self.networkingLoadingIndicator.endLoadingAnimation()
                completion(error)
                return
            }
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: SETUP USER INFO METHOD
    
    func fetchUser(_ uid: String, handleCompletion: @escaping (_ wasSuccessful: Bool) -> Void) {
        let currentUserDocumentReference = Firestore.firestore().collection(.environment).document(.users).collection(.users).document(uid)
        
        currentUserDocumentReference.getDocument { currentUserDocumentSnapshot, error in
            guard let snapshot = currentUserDocumentSnapshot,
                  let userID = snapshot.get(.userID) as? String,
                  let email = snapshot.get(.email) as? String,
                  let isOnline = snapshot.get(.isOnline) as? Bool,
                  let isTyping = snapshot.get(.isTyping) as? Bool,
                  let lastLogin = (snapshot.get(.lastLogin) as? Timestamp)?.dateValue(),
                  let deviceToken = Messaging.messaging().fcmToken,
                  let name = snapshot.get(.name) as? String,
                  let pronouns = snapshot.get(.pronouns) as? String,
                  let profileImageURL = snapshot.get(.profileImageURL) as? String,
                  let friendRequestCode = snapshot.get(.friendRequestCode) as? String,
                  error == nil else {
                // TODO: present error message to user
                handleCompletion(false)
                return
            }
            
            
            let smileNotes = currentUserDocumentReference.collection(.smileNotes).getDocuments(completion: { (querySnapshot, error) in
                guard let smileNoteIDs = querySnapshot?.documents.compactMap({documentSnapshot -> String? in
                    return documentSnapshot.get(.messageID) as? String
                }) else {
                    handleCompletion(false)
                    return
                }
                
                let smileNotes = smileNoteIDs.map { SmileNote(messageID: $0) }
                
                MRUser.current = MRUser(userID: userID,
                                        email: email,
                                        isOnline: isOnline,
                                        isTyping: isTyping,
                                        lastLogin: lastLogin,
                                        deviceToken: deviceToken,
                                        name: name,
                                        pronouns: pronouns,
                                        profileImageURL: profileImageURL,
                                        friendRequestCode: friendRequestCode,
                                        smileNotes: smileNotes)
                handleCompletion(true)
            })
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func checkForExistingEmail(_ email: String, completion: @escaping (_ errorMessage: String?) -> Void) {
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            self.networkingLoadingIndicator.endLoadingAnimation()
            if methods == nil {
                return completion(nil)
            } else {
                return completion("This email is already in use.")
            }
        }
    }
    func checkForExistingUserID(with UserID: String, completion: @escaping (_ errorMessage: String?)-> Void) {
        Database.database().reference().child("users").queryOrdered(byChild: "UserID").queryEqual(toValue: UserID).observeSingleEvent(of: .value) { (sanpshot) in
            if sanpshot.exists() == true {
                return completion(nil)
            } else {
                return completion("This UserID is already in use.")
            }
            sanpshot.exists() // it will return true or false
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: SIGN UP USER METHOD
    
    func registerUser(_ name: String, _ email: String, _ password: String, _ profileImage: UIImage?, _ userID: String,_ pronoun:String, completion: @escaping (_ error: String?) -> Void) {
        func newFriendRequestCode() -> String {
            let numDigits = 6
            
            func randomCodeCharacter() -> Character? {
                return "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()
            }
            
            var code = ""
            while code.count < numDigits {
                if let randomCharacter = randomCodeCharacter() {
                    code.append(randomCharacter)
                }
            }
            
            return code
        }
        
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            guard let uid = dataResult?.user.uid else {
                completion("Error occured, try again!")
                return
            }
            let imageToSend = profileImage ?? UIImage(named: "DefaultUserImage")
            self.uploadProfileImageToStorage(imageToSend!) { (url, error) in
                if let error = error {
                    completion(error.localizedDescription)
                    return
                }
                guard let url = url else { return }
                
                let user = MRUser(userID: userID,
                                  email: email,
                                  isOnline: true,
                                  isTyping: false,
                                  lastLogin: nil,
                                  deviceToken: nil,
                                  name: name,
                                  pronouns: pronoun,
                                  profileImageURL: url.absoluteString,
                                  friendRequestCode: newFriendRequestCode(),
                                  smileNotes: [])
                self.addUserToDatabase(user)
                completion(nil)
            }
        }
    }
    
    private func addUserToDatabase(_ user: MRUser) {
        Firestore.firestore().collection(.environment).document(.users).collection(.users).addDocument(data: user.dictionary)
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
