//
//  FriendsProvider.swift
//  MadlyRad
//
//  Created by Rafael Rincon on 1/31/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import FirebaseFirestore

struct FriendsProvider {
    
    static func getFriendIDs(of user: MRUser, handleCompletion: @escaping ([String]?, Error?) -> ()) {
        Firestore
            .firestore()
            .collection(.environment)
            .document(.relationships)
            .collection(.relationships)
            .whereField(.userID, in: [user.userID])
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    handleCompletion(nil, error)
                } else {
                    handleCompletion(querySnapshot?.documents.compactMap({ relatedSnapshot in
                        relatedSnapshot.get("status") as? String == "friend" ? relatedSnapshot : nil
                    }).compactMap({ friendSnapshot in
                        friendSnapshot.get(.userID) as? String
                    }), nil)
                }
            }
    }
    
}
