//
//  Shakingcoool.swift
//  MadlyRad
//
//  Created by JOJO on 8/4/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
class ViewController5: UIViewController {
    

    @IBOutlet var myImageView: UIImageView!
    var ref = DatabaseReference.init()
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController5.openGalleryClick(tapGesture:)))
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(tapGestureRecognizer)
        myImageView.backgroundColor = UIColor.red
        
    }

    @objc func openGalleryClick(tapGesture: UITapGestureRecognizer){
        self.setupImagePicker()
    }

    @IBAction func btnSaveClick(_ sender: UIButton) {
         self.saveFIRData()
    }

    func saveFIRData(){
        self.uploadMedia(image: myImageView.image!){ url in
            self.saveImage(userName: "", profileImageURL: url!){ success in
                if (success != nil){
                    self.dismiss(animated: true, completion: nil)
                }

            }
        }
    }
    func download(image :UIImage, completion: @escaping ((_ url: URL?) -> ())){
   
    }

    func uploadMedia(image :UIImage, completion: @escaping ((_ url: URL?) -> ())) {
        let hi = "shakingcool/\(Auth.auth().currentUser!.uid)/\("shakingcoolimage")"
        let storageRef = (Storage.storage().reference().child(hi))
        let imgData = self.myImageView.image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metaData) { (metadata, error) in
            if error == nil{
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
            }else{
                print("error in save image")
                completion(nil)
            }
        }
    }

    func saveImage(userName:String, profileImageURL: URL , completion: @escaping ((_ url: URL?) -> ())){
        let dict = ["profileImageURL": profileImageURL.absoluteString] as [String : Any]
        self.ref.child("chat").childByAutoId().setValue(dict)
    }

}

extension ViewController5: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func setupImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.allowsEditing = true

            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        myImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }


}
