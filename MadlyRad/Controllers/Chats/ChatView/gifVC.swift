//
//  gifVC.swift
//  MadlyRad
//
//  Created by Zion Asemota on 10/7/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseStorage
import GiphyUISDK
import GiphyCoreSDK

class gifVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }
    
    
    @IBOutlet weak var gifCollectionView: UICollectionView!
    
    
    
    
    private let reuseIdentifier = "gifCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var gifNumbers = 14
    var sendGif:((Data) -> Int)?
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = view.frame.size.height
        let width = view.frame.size.width
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width * 0.25, height: width*0.25)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifNumbers
    }
    
    
        

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! gifCell
        
        let uniqueId = Int.random(in: Int.min...Int.max)
        cell.tag = uniqueId
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let gifRef = storageRef.child("AnimatedStickers")
        
        
        
        //function that loops through each child element inside animated stickers
        gifRef.listAll { (result, error) in
            
            
            
            if let error = error {
                
                print("Error occured with gif.")
                
            }
            
            
            let itemArr = result.items
            
            let gifName = itemArr[indexPath.row].name
            
            var gifItem = gifRef.child(gifName)
            gifItem.getData(maxSize: 100000000000) { (data, error) in
                if let error = error {
                    print("Error loading gif")
                } else {
                    
                    do {
                        
                        //let gif = try UIImage(gifData: data!, levelOfIntegrity: 1)
                        
                        let activityIndicator = UIActivityIndicatorView(style: .gray)
                        
                        
                        cell.addSubview(activityIndicator)
                        
                        activityIndicator.frame = cell.bounds
                        activityIndicator.startAnimating()
                        activityIndicator.hidesWhenStopped = true
                         
                        
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating()
                            let gif = UIImage.gifImageWithData(data!)
                            cell.gifImage.image = gif
                        }
                        
                        
                        //let gif = UIImage(g)
                        
                        //cell.gifImage.image = gif
                        
                        
                        
                        
                        
                        
                        //cell.gifImage.setGifImage(gif, loopCount: -1)
                        
                       
                    
                        //cell.gifImage.animationDuration = 0.1
                        
                        
                        
            
                        
                    }
                    catch {
                        print(error)
                    }
                    
                }
            }
        }
   
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let gifRef = storageRef.child("AnimatedStickers")
        
        gifRef.listAll { (result, error) in
            
            
            
            if let error = error {
                
                print("Error occured with gif.")
                
            }
            
            
            let itemArr = result.items
            
            let gifName = itemArr[indexPath.row].name
            
            
            var gifItem = gifRef.child(gifName)
            gifItem.getData(maxSize: 100000000000) { (data, error) in
                if let error = error {
                    print("Error loading gif")
                } else {
                    
                    do {
                        
                        self.dismiss(animated: true, completion: nil)
                        
                        self.sendGif!(data!)
                      
                        
                        
                        
                    }
                    catch {
                        print(error)
                    }
                    
                }
            }
        }
        
        
    }
    
    
    
    
    
}



