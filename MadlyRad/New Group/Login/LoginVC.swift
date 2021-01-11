//
//  File.swift
//  MadlyRad
//
//  Created by JOJO on 7/19/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase



class LoginVC: UIViewController {
    
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPwd: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
    }
    @IBAction func btnActionForgetPwd(_ sender: Any) {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnAction(_ sender: Any) {
        if self.txtUsername.text == "" || self.txtPwd.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter Email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: self.txtUsername.text!, password: self.txtPwd.text!) { (user, error) in
                if error == nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "Main")
                    self.present(controller, animated: true, completion: nil);
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: "Email does not exist in our Data base.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)

                }
            }
        }
    }
}

