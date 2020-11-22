//
//  shakingscool.swift
//  MadlyRad
//
//  Created by JOJO on 8/3/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//


import UIKit

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //

private let imgCache = NSCache<NSString, UIImage>()

// UIIMAGEVIEW EXTENSION THAT LOADS IMAGES FROM FIREBASE STORAGE AND CACHES THEM.

extension UIImageView {
    //codeword
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // NETWORKING ACTIVITY INDICATOR
    
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        return activityIndicator
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func loadImage(url: String){
        self.image = nil
        if let img = imgCache.object(forKey: url as NSString) {
            self.image = img
            return
        }
        isUserInteractionEnabled = false
        backgroundColor = .lightGray
        let indicator = activityIndicator
        DispatchQueue.main.async {
            indicator.startAnimating()
        }
        let imgUrl = URL(string: url)
        if imgUrl == nil {
            return
        }
        let task = URLSession.shared.dataTask(with: imgUrl!) { (data, response, error) in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data){
                    self.backgroundColor = .clear
                    self.isUserInteractionEnabled = true
                    indicator.stopAnimating()
                    self.alpha = 1
                    imgCache.setObject(image, forKey: url as NSString)
                    self.image = image
                }
            }
        }
        task.resume()
    }
    
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //

