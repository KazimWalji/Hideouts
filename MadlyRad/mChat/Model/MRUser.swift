//
//  User.swift
//  MadlyRad
//
//  Created by Rafael Rincon on 1/10/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import Foundation

struct MRUser: Encodable {
    
    static var current: MRUser?
    
    let userID: String
    let email: String
    let isOnline: Bool
    let isTyping: Bool
    let lastLogin: Date?
    let deviceToken: String
    let firstName: String
    let lastName: String
    let pronouns: String
    let profileImageURL: String
    let friendRequestCode: String
    let smileNotes: [SmileNote]
}

struct SmileNote: Encodable {
    let messageID: String
}
