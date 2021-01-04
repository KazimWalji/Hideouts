//  FirebaseData.swift
//  MadlyRad
//
//  Created by Krish Mody on 8/26/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//



import Foundation
import Firebase
import FirebaseFirestore
import Combine

let dbCollection = Firestore.firestore().collection("notification")
let firebaseData = FirebaseData()
let legacyServerKey = "AAAAlyshlg4:APA91bF65UAu1r4Yf-r4MuOqgRALVPWgDiCbz1Wj9sp4ONQBr-Hfl0jna-RndXyRq50TJQI-faN3SO46g5LaTh5HxqLP0dOKIVfr7Jr4biKGbzEh8vxpfmMwSrjpa7w0CSru6-OTZ8rf"

class FirebaseData: ObservableObject {
    var sender: String?
    @Published var didChange = PassthroughSubject<[ThreadDataType], Never>()
    @Published var data = [ThreadDataType](){
        didSet{
            didChange.send(data)
        }
    }
    
    init() {
        readData()
    }
    
    
    func createData(sender: String, msg1: String) {
        dbCollection.document().setData(["id" : dbCollection.document().documentID, "content": msg1, "userID": sender, "date": makeToday(), "isRead": false]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else {
                print("Create data success")
            }
        }
    }
    
    func readData() {
        dbCollection.addSnapshotListener { (documentSnapshot, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else {
                print("Read data success")
            }
            
            documentSnapshot!.documentChanges.forEach { diff in
                
                if (diff.type == .added) {
                    let msgData = ThreadDataType(id: diff.document.documentID, userID: diff.document.get("userID") as! String, content: diff.document.get("Content") as! String, date: diff.document.get("date") as! String, isRead: diff.document.get("isRead") as! Bool)
                    self.data.append(msgData)
                }
                
                if (diff.type == .modified) {
                    self.data = self.data.map { (eachData) -> ThreadDataType in
                        var data = eachData
                        if data.id == diff.document.documentID {
                            data.content = diff.document.get("content") as! String
                            data.userID = diff.document.get("userID") as! String
                            data.date = diff.document.get("date") as! String
                            data.isRead = diff.document.get("isRead") as! Bool
                            
                            return data
                        } else {
                            return eachData
                        }
                    }
                }
                
                if (diff.type == .removed) {
                    var removeRowIndex = 0
                    for index in self.data.indices {
                        if self.data[index].id == diff.document.documentID {
                            removeRowIndex = index
                        }
                    }
                    self.data.remove(at: removeRowIndex)
                }
            }
        }
    }
    
    
    func updateData(id: String, isRead: Bool) {
        dbCollection.document(id).updateData(["isRead": isRead]) { (err) in
            if err != nil {
            print((err?.localizedDescription)!)
            return
        } else {
            print("Update data success")
            }
        }
    }
    
    func sendMessageTouser(datas: FirebaseData, to token: String, title: String, body: String) {
        print("sendMessageTouser()")
        var isNotRead: Int = 0
        for data in datas.data {
            if !data.isRead && title == data.userID {isNotRead += 1}
        }
        isNotRead += 1
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String: Any] = ["to" : token,
                                          "priority": "high",
                                          "notification" : ["title" : title, "body" : body, "badge" : isNotRead],
                                          "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(legacyServerKey)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, serror) in
            do {
                if let jsonData = data {
                    if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:]n](jsonDataDict))")
                        firebaseData.createData(sender: title, msg1: body)
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}

