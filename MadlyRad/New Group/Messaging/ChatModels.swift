//
//  ChatModels.swift
//  MadlyRad
//
//  Created by JOJO on 7/24/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//


import Foundation
import CoreLocation
import MessageKit

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .emoji(_):
            return "emoji"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "customc"
        case .location(_):
            return ""
        case .audio(_):
            return ""
        }
    }
}

struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
    public var sentDate: Date
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
//possible location adder for emercency?
struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
}
