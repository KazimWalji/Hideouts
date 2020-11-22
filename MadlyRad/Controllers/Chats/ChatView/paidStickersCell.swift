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


class PaidStickerVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    let productID = "com.RobRoe.Hideouts.stickers"
    
        func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) { //handles transaction
        for transaction in transactions
        {
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .purchased, .restored:
                let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PaidStickerVC") as! PaidStickerVC
                self.present(controller, animated: true, completion: nil)

                    SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
           case let .failed:
            print("failed: \(transaction.error)")
            SKPaymentQueue.default().finishTransaction(transaction)
            default:
                print("finsish")
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
        }
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) { //asking apple to process payment
        if let product = response.products.first {
            print(response.products.count)
            myProduct = product
            print(product.productIdentifier)
            print(product.price)
            print(product.localizedDescription)
            print(product.localizedTitle)
        }
        else{
            print(response.products.count)
            print(response.products.first)
        }
    }




    var myProduct: SKProduct? //product being putchased


    
    private let reuseIdentifier = "PaidStickerCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
 

    var numberOfStickers = 19
    var chatVC:ChatVC?
    var sendSticker:((UIImage) -> Int)?
    //var stickers = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let stickersRef = storageRef.child("Stickers")
        var sticker = stickersRef

        
        /*stickers.reserveCapacity(19)
            for i in 1...19 {
                sticker = stickersRef.child("Sticker\(i).png")
            
                DispatchQueue.main.async {
                    sticker.getData(maxSize: 100000000) { data, error in
                    if let error = error {
                        print("error in downloading image:\n\n\n   \(error)")
                        //self.stickers.append(data)
                    } else {
                        //print(data!)
                        self.stickers.append(data as! Data)
                    
                        //print("image \(i) added")
                        // break errorcheck
                    }
                    }
                }
            print(i)
            
            //print("One image uploaded")
        }*/
        print("loop exited")
        
        guard let myProduct = self.myProduct else
                   {
                       return
                   }
                   if SKPaymentQueue.canMakePayments() { //sends payment
                       print("working")
                       let payment = SKPayment(product: myProduct)
                       SKPaymentQueue.default().add(self)
                       SKPaymentQueue.default().add(payment)
                   }
        print("\n\n\n\n\n\(self.numberOfStickers)\n\n\n\n\n")
    }
    func fetchProducts()
    {
        let request = SKProductsRequest(productIdentifiers: [productID])
        request.delegate = self
        request.start()
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
        var sticker = stickersRef.child("Sticker\(indexPath.row + 1).png")
        
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
        let stickersRef = storageRef.child("Stickers")
        var sticker = stickersRef.child("Sticker\(indexPath.row + 1).png")
        sticker.getData(maxSize: 100000000) { data, error in
            if let error = error {
                print("Error loading image")
            }
            else {
                self.dismiss(animated: true, completion: nil)
                print(UIImage(data: data!))
                self.sendSticker?(UIImage(data: data!)!)
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


