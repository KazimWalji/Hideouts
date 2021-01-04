//
//  ViewController.swift
//  MadlyRad
//
//  Created by JOJO on 7/18/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

//https://www.youtube.com/watch?v=uO9OqS1hdoE
//https://www.youtube.com/watch?v=Eg3vz6RFiIU
//https://www.youtube.com/watch?v=XmyiRzeoSJE
class UserProfile: UIViewController {
    var databaseRef: DatabaseReference!
    @IBOutlet weak var userName: UITextField!
    
    
    func userPicAndName(_user: User) {
        let uName = userName.text
        let userN = [ "username": uName,
                      "profilePicture": "gs://madlyradlabs.appspot.com/image0-6.jpg"]
        (self.databaseRef.child("profile") as AnyObject).child(_user.uid).updateChildValues(userN as [AnyHashable : Any]) {
            (error, ref) in
            if error != nil{
                print (error!)
                return
            }
            print("W")
        }
    }
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let uName = userName.text
            else {return}
        userPicAndName(_user: uName)

        
    }
    
}
