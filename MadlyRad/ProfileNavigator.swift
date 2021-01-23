//
//  ProfileNavigator.swift
//  MadlyRad
//
//  Created by JOJO on 7/30/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ProfileNavigator: UIViewController {
        @IBAction func Loggout(_ sender: Any) {
       AppManager.shared.logout()
       
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let controller = storyboard.instantiateViewController(withIdentifier: "navLogin")
       self.present(controller, animated: true, completion: nil);
        
    }
    
    
}
