//
//  ProfilePic.swift
//  MadlyRad
//
//  Created by JOJO on 7/21/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Firebase

class ProfilePic: UIViewController {
    var image: UIImage? = nil
    
    func setupAvatar()  {
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
    avatar.addGestureRecognizer(tapGesture)
        
    }

    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }

    @IBOutlet weak var avatar: UIImageView!
    @IBAction func userNameImage(_ sender: Any) {
            guard let imageSelected = self.image else {
            print("hi")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        Auth.auth().createUser(withEmail: "testing@gmail.com", password: "String") { (authDataResult, error) in
            if error != nil{
                print(error!.localizedDescription)
            return
            }
            if let authData = authDataResult {
            print(authData.user.uid)
                var dict : Dictionary<String, Any> = [
                "email": authData.user.email,
                "uid": authData.user.uid,
                "profileImageUrl": "",
            ]
                let storageRef = Storage.storage(url:"gs://madlyradlabs.appspot.com")
                let storageProfileRef = (storageRef.child("profile").child(authData.user.uid)
        
    
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metadata, completion: { (storageMetaData, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    return
    }
        storageProfileRef.downloadURL(completion: { (url, error) in
            if let metaImageUrl = url?.absoluteString {
                dict["profileImageUrl"] = metaImageUrl
            
            }
            
        })
    })
                ((Database.database().referance().child("users").child(authData.user.uid) as AnyObject).updateChildValues(dict, withCompletionBlock: {
                (error, ref) in
        if error == nil {
            print("done")
    }
    })

}
}
    }
    
}
extension ProfilePic: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            avatar.image = imageSelected
            image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatar.image = imageOriginal
            image = imageOriginal

    }
    picker.dismiss(animated: true, completion: nil)
    
}
}
