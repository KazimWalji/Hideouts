//
//  SignUpVc.swift
//  MadlyRad
//
//  Created by JOJO on 7/24/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//
/*
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class SignUpVC: UIViewController, UITextFieldDelegate{

    @IBOutlet var imgUserProfile: UIImageView!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPwd: UITextField!
  
    let storage = Storage.storage()
    var ref: DatabaseReference!
    let data = Data()
    let imagePicker = UIImagePickerController()
    
    @IBAction func btnAction(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1

        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }

    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.txtFirstName:
            self.txtLastName.becomeFirstResponder()
        case self.txtLastName:
            self.txtEmail.becomeFirstResponder()
        case self.txtEmail:
            self.txtPwd.becomeFirstResponder()
        default:
            self.txtPwd.resignFirstResponder()
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFirstName.tag = 0
        self.txtLastName.tag = 1
        self.txtEmail.tag = 2
        self.txtPwd.tag = 3

        imagePicker.delegate = self
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtEmail.delegate = self
        self.txtPwd.delegate = self
        
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        if txtFirstName.text == "" && txtLastName.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter Firstname & Lastname", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        if txtEmail.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        if (self.imgUserProfile.image == #imageLiteral(resourceName: "YouAvatar"))
        {
            let alert = UIAlertController(title: "Alert", message: "Please Select Profile Picture", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPwd.text!) { (user, error) in
                if error == nil {
                    self.ref = Database.database().reference()
                    var data = NSData()
                    data = (self.imgUserProfile.image?.jpegData(compressionQuality: 0.8) as NSData?)!
                    let storageRef = Storage.storage().reference()
                    let filePath = "\(Auth.auth().currentUser!.uid)/\("imgUserProfile")"
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                    storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                    }
                    let fullname = ["Firstname": self.txtFirstName.text! , "Lastname": self.txtLastName.text!]
                    self.ref.child("users").child((user?.user.uid)!).setValue(["username": fullname])
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "DOBVC")
                    self.present(controller, animated: true, completion: nil);
                    
                }
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                }
            }
        }
    }

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            imgUserProfile.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
*/
