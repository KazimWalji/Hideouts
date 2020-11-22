//
//  ShakingCoolPickerViewController.swift
//  MadlyRad
//
//  Created by JOJO on 8/3/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit

class ShakingCoolPicker: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

@IBOutlet var imageView: UIImageView!
@IBOutlet var imageView1: UIImageView!
@IBOutlet var imageView2: UIImageView!
let imagePicker = UIImagePickerController()
let imagePicker1 = UIImagePickerController()
let imagePicker2 = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
     imagePicker.delegate = self
    imagePicker1.delegate = self
        imagePicker2.delegate = self
    }
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
            
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func loadImageButtonTapped1(_ sender: UIButton) {
        imagePicker1.allowsEditing = false
        imagePicker1.sourceType = .photoLibrary
            
        present(imagePicker1, animated: true, completion: nil)
    }
    @IBAction func loadImageButtonTapped2(_ sender: UIButton) {
        imagePicker2.allowsEditing = false
        imagePicker2.sourceType = .photoLibrary
            
        present(imagePicker2, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController1(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage1 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView1.contentMode = .scaleAspectFit
            imageView1.image = pickedImage1
        }

        dismiss(animated: true, completion: nil)
    }
    func imagePickerController2(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage2 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView2.contentMode = .scaleAspectFit
            imageView2.image = pickedImage2
        }

        dismiss(animated: true, completion: nil)
    }
}
