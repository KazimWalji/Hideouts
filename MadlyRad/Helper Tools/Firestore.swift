//
//  Firestore.swift
//  MadlyRad
//
//  Created by Rafael Rincon on 1/10/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import FirebaseFirestore

/// A component of a path in the Firestore database. Don't use rawValue direclty, use stringValue.
enum FirestorePath: String {
    
    case environment

    case users
    case userID
    case email
    case isOnline
    case isTyping
    case lastLogin
    case notificationTokens
    case name
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
    
    case url
    
    case relationships
    
    var stringValue: String {
        get {
            if self == .environment {
                #if DEBUG
                return "dev1"
                #else
                return "prod"
                #endif
            } else {
                return rawValue
            }
        }
    }
}


extension Firestore {
    func collection(_ path: FirestorePath) -> CollectionReference {
        return collection(path.stringValue)
    }
}

extension CollectionReference {
    func document(_ path: FirestorePath) -> DocumentReference {
        return document(path.stringValue)
    }
    
    func whereField(_ field: FirestorePath, in values: [Any]) -> Query {
        return whereField(field.stringValue, in: values)
    }
    
    func whereField(_ field: FirestorePath, isEqualTo value: Any) -> Query {
        return whereField(field.stringValue, isEqualTo: value)
    }
    
}

extension DocumentReference {
    func collection(_ path: FirestorePath) -> CollectionReference {
        return collection(path.stringValue)
    }
}

extension DocumentSnapshot {
    func get(_ path: FirestorePath) -> Any? {
        return get(path.stringValue)
    }
}
