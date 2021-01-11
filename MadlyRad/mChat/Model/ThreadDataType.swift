//
//  ThreadDataType.swift
//  MadlyRad
//
//  Created by Krish Mody on 8/26/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//


import Foundation
import SwiftUI

let messageSimulatorSender = "Simulator"

struct ThreadDataType: Identifiable {
var id: String
var userID: String
var content: String
var date: String
var isRead: Bool = false
}

func makeToday() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: date)
}

func rowTrailing(userID: String, senderName: String) -> HorizontalAlignment {
    if userID == senderName {
        return HorizontalAlignment.trailing
    } else {
        return HorizontalAlignment.leading
    }
}

let threadDataTest = [ThreadDataType(id: "id1", userID: messageSimulatorSender, content: "content1", date:makeToday())]

