//
//  Friend.swift
//  MadlyRad
//
//  Created by Alex Titov on 1/12/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import Foundation
import UIKit
import AVKit

struct Friend {
    var name: String
    var age: Int
    var friendListNumber: Int
    var status: Int
    var image: String
    var starCoords: [Int]

    var starButton: UIButton?
    var starVideoLooper: AVPlayerLooper?
    
    init(name: String, age: Int, friendListNumber: Int, status: Int, image: String, starCoords: [Int]) {
        self.name = name
        self.age = age
        self.friendListNumber = friendListNumber
        self.status = status
        self.image = image
        self.starCoords = starCoords
    }
}
