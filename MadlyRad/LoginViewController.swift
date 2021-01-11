//
//  LoginViewController.swift
//  MadlyRad
//
//  Created by JOJO on 7/19/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var phoneNum: UITextField!
    override func viewDidLoad() {
           super.viewDidLoad()
    }
    
    @IBAction func sendCode(_ sender: Any) {let alert = UIAlertController(title: "Phone number", message: "Is this your phone number? \n \(phoneNum.text!)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneNum.text!, uiDelegate: nil) { (verificationID, error) in
                    
                    if error != nil {
                        print("eror: \(String(describing: error?.localizedDescription))")
                    } else {
                        let defaults = UserDefaults.standard
                        defaults.set(verificationID, forKey: "authVID")
                        self.performSegue(withIdentifier: "code", sender: Any?.self)
                    }
                }
            }
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
     override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
