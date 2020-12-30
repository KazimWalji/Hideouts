//
//  PinVC.swift
//  MadlyRad
//
//  Created by XCodeClub on 2020-12-13.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import SafariServices
import FirebaseDatabase
import FirebaseAuth

class PinVC: UIViewController {
    let tableView = UITableView()
    var working: UIViewController!
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Pin"
        //view.backgroundColor = .white
        view.backgroundColor = .white
//background
        let title = UITextField(frame: CGRect(x: self.view.center.x, y: 100, width: 325, height: 50))
        title.center.x = self.view.center.x
        title.text = "Your Pin:"
        title.textColor = UIColor.black
        self.view.addSubview(title)
        let pinDisplay = UITextField(frame: CGRect(x: self.view.center.x+100, y: 100, width: 325, height: 50))
        pinDisplay.textColor = UIColor.black
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid //user id
            
        self.ref?.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("pin"){
                self.ref?.child("users").child(userID!).child("pin").observeSingleEvent(of: .value, with: { (snapshot) in
                    pinDisplay.text = snapshot.value as! String
                    self.view.addSubview(pinDisplay)
                })
                
                //self.view.addSubview(pinDisplay)
                
            } else{
                
                self.ref?.child("pins").observeSingleEvent(of: .value, with: { (snapshot) in
                    var pin = ""
                    repeat{
                    pin = ""
                    pin = randomString(length: 6)
                        
                    
                    print(pin)
                    } while(snapshot.hasChild(pin))
                     self.ref?.child("users").child(userID!).child("pin").setValue(pin)
                    self.ref?.child("pins").child(pin).setValue("pin")
                    pinDisplay.text = pin
                    self.view.addSubview(pinDisplay)
                    
                    
                })
                
                
                
                
            }
        })
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

func randomString(length: Int) -> String {
  let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
