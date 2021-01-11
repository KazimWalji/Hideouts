//
//  Message.swift
//  MadlyRad
//
//  Created by Rafael Rincon on 1/10/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import FirebaseFirestore

struct Message {
    
    enum Status: String {
        case sent, delivered, read, deleted
    }
    
    let messageID: String
    /// the message that this message replies to
    let precipitatingMessageID: String
    let senderID: String
    let conversationID: String
    let textContent: String
    let status: Status
    let videoURL: String
    let audioURL: String
    let timeSent: Date
    let imageURLs: [String]
    let usersWithoutAccess: [MRUser]

    init?(firestoreDocumentSnapshot: DocumentSnapshot, imageURLs: [String], usersWithoutAccess: [MRUser]) {
        guard let messageID = firestoreDocumentSnapshot.get(.messageID) as? String,
              let precipitatingMessageID = firestoreDocumentSnapshot.get(.precipitatingMessageID) as? String,
              let senderID = firestoreDocumentSnapshot.get(.senderID) as? String,
              let conversationID = firestoreDocumentSnapshot.get(.conversationID) as? String,
              let textContent = firestoreDocumentSnapshot.get(.textContent) as? String,
              let statusString = firestoreDocumentSnapshot.get(.status) as? String,
              let status = Message.Status(rawValue: statusString),
              let videoURL = firestoreDocumentSnapshot.get(.videoURL) as? String,
              let audioURL = firestoreDocumentSnapshot.get(.audioURL) as? String,
              let timeSent = firestoreDocumentSnapshot.get(.timeSent) as? Date else { return nil }
        self.messageID = messageID
        self.precipitatingMessageID = precipitatingMessageID
        self.senderID = senderID
        self.conversationID = conversationID
        self.textContent = textContent
        self.status = status
        self.videoURL = videoURL
        self.audioURL = audioURL
        self.timeSent = timeSent
        self.imageURLs = imageURLs
        self.usersWithoutAccess = usersWithoutAccess
    }
    
}
