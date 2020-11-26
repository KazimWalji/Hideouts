//
//  DiscussionFirebase.swift
//  MadlyRad
//
//  Created by JOJO on 7/26/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

public class DiscussionFirebase: DiscussionManager {
    
    var ref = Database.database().reference().child("discussions")
    
    public func list(onSuccess: @escaping ([Discussion]) -> Void, onError: ErrorClosure?) {
        
        self.ref.observe(.value, with: { (snapshot) in
                        
            let discussions = snapshot.children
                .flatMap({ Discussion.mapper(snapshot: $0 as! DataSnapshot) })
                .sorted(by: { $0.uid > $1.uid })
  
            /*
            var discussions = [Discussion]()
            
            for child in snapshot.children {
                let discussion = Discussion.mapper(snapshot: child as! DataSnapshot)
                discussions.append(discussion!)
            }
            
            discussions = discussions.sorted(by: { (discussion1, discussion2) -> Bool in
                return discussion1.uid < discussion2.uid
            })
            */
            
            onSuccess(discussions)
        
        }) { (error) in
            print(error)
        }
        
        
    }
    
}
