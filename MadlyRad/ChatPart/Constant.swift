//
//  Constant.swift
//  MadlyRad
//
//  Created by JOJO on 7/22/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

struct K {
    
    static let appName = "Hideouts"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandDarkPurple"
        static let lightPurple = "BrandLightGreen"
        static let blue = "BrandPurple"
        static let lighBlue = "BrandGreen"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
    
}
