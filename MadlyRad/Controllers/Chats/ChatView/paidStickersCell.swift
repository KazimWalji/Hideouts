//
//  StickerVC.swift
//  MadlyRad
//
//  Created by Siddh Bamb on 8/24/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import StoreKit
import FirebaseCore
import FirebaseStorage


class PaidStickerVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
   
    
    private let reuseIdentifier = "PaidStickerCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
 

    var numberOfStickers = 19
    var chatVC:ChatVC?
    var sendSticker:((UIImage) -> Int)?
    //var stickers = [Data]()
    
    var models = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let stickersRef = storageRef.child("PaidStickers")
        var sticker = stickersRef
        SKPaymentQueue.default().add(self)
        fetchProducts()
        print("loop exited")
        print("\n\n\n\n\n\(self.numberOfStickers)\n\n\n\n\n")
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = view.frame.size.height
        let width = view.frame.size.width
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width * 0.25, height: width*0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfStickers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PaidStickerImageCell
        
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let stickersRef = storageRef.child("PaidStickers")
        var sticker = stickersRef.child("\(indexPath.row + 1)Penguin Sticker .png")
        
        sticker.getData(maxSize: 100000000) { data, error in
            if let error = error {
                print("Error loading image")
            }
            else {
                cell.paidstickerimage.image = UIImage(data: data!)
            }
        }
        
        
         // make cell more visible in our example project
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("Selected Sticker\(indexPath.item+1)!")
        // indexPath.item+1
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let stickersRef = storageRef.child("PaidStickers")
        var sticker = stickersRef.child("\(indexPath.row + 1)Penguin Sticker .png")
        sticker.getData(maxSize: 100000000) { data, error in
            if let error = error {
                print("Error loading image")
            }
            else {
                self.dismiss(animated: true, completion: nil)
                print(UIImage(data: data!))
                if(UserDefaults.standard.bool(forKey: "paidStickers"))
                {
                    print("can pay")
                    self.sendSticker?(UIImage(data: data!)!)
                }
                else
                {
                    print("can't pay")
                    print(self.models[0].localizedTitle)
                    let payment = SKPayment(product: self.models[0])
                    SKPaymentQueue.default().add(payment)
                }
                
            }
        }

        
    }
    
    func fetchProducts()
    {
        let request = SKProductsRequest(productIdentifiers: ["com.RobRoe.Hideouts.newstickers"])
        request.delegate = self
        request.start()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async
        {
            self.models = response.products
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions
        {
            switch transaction.transactionState
            {
            case .purchasing:
                print("purchasing")
                break
            case .purchased, .restored:
                UserDefaults.standard.set(true, forKey: "paidStickers")
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .deferred:
                //SKPaymentQueue.default().finishTransaction(transaction)
                //SKPaymentQueue.default().remove(self)
                break
            @unknown default:
               // SKPaymentQueue.default().finishTransaction(transaction)
                //SKPaymentQueue.default().remove(self)
                break
            }
        }
    }
    
    
   
}
 
/*// MARK: - UICollectionViewDataSource
extension StickerVC {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as UICollectionViewCell
        //let image = stickers[indexPath.row]
        //cell.addSubview(UIImageView(image: UIImage(data: image)!))
        // Configure the cell
        print(self.stickers.count)
        cell.backgroundColor = UIColor.cyan
        return cell
    }
  //1
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  //2
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.stickers.count
  }*/
  
  //3
  /*override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
  {
    let cell = collectionView
      .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as UICollectionViewCell
    let image = stickers[indexPath.row]
    cell.addSubview(UIImageView(image: image))
    // Configure the cell
    return cell
  }
    
    
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // handle tap events
       print("Selected #\(indexPath.item)!")
   }*/
//}


