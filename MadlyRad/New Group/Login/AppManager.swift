//
//  Terms(mainvc).swift
//  MadlyRad
//
//  Created by JOJO on 7/20/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class AppManager {
    static let shared = AppManager()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var appContainer: AppContainerVC!
    
    private init() { }
    
    
    func showApp() {
            var viewController: UIViewController
            if Auth.auth().currentUser == nil {
                viewController = storyboard.instantiateViewController(withIdentifier: "navLogin")
            
            } else {
                viewController = storyboard.instantiateViewController(withIdentifier: "Main")
        }
        appContainer.present(viewController, animated: true, completion: nil)
    
    }
    func logout() {
        try! Auth.auth().signOut()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        
        
    }
    
}
