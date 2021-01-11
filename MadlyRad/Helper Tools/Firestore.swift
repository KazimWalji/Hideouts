//
//  Firestore.swift
//  MadlyRad
//
//  Created by Rafael Rincon on 1/10/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import FirebaseFirestore

enum FirestorePath: String {
    case dev1
    
    case users
    case userID
    case email
    case isOnline
    case isTyping
    case lastLogin
    case deviceToken
    case firstName
    case lastName
    case pronouns
    case profileImageURL
    case friendRequestCode
    case smileNotes
    case messageID
    
    case messages
    case precipitatingMessageID
    case senderID
    case conversationID
    case textContent
    case status
    case videoURL
    case audioURL
    case timeSent
    case imageURLs
    case usersWithoutAccess
}


extension Firestore {
    func collection(_ path: FirestorePath) -> CollectionReference {
        return collection(path.rawValue)
    }
}

extension CollectionReference {
    func document(_ path: FirestorePath) -> DocumentReference {
        return document(path.rawValue)
    }
    
    func whereField(_ field: FirestorePath, in values: [Any]) -> Query {
        return whereField(field.rawValue, in: values)
    }
    
    func whereField(_ field: FirestorePath, isEqualTo value: Any) -> Query {
        return whereField(field.rawValue, isEqualTo: value)
    }
    
}

extension DocumentReference {
    func collection(_ path: FirestorePath) -> CollectionReference {
        return collection(path.rawValue)
    }
}

extension DocumentSnapshot {
    func get(_ path: FirestorePath) -> Any? {
        return get(path.rawValue)
    }
}
