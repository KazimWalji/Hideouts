//
//  ConversationModels.swift
//  MadlyRad
//
//  Created by JOJO on 7/24/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//


import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
