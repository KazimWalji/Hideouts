//
//  PLSWORK.swift
//  MadlyRad
//
//  Created by JOJO on 7/26/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import Foundation

let gopherName = ["normalGopher", "tripleGopher", "girlGopher", "hole"] //change to fit new game

class Gopher
{
    private var point: Int
    private var name: String
    
    init()
    {
        name = gopherName[3]
        point = 0
    }
    
    func getName() -> String {
        return name
    }
    
    func getPoint() -> Int {
        return point
    }
    
    func randomChangeType() {
        let type = Int.random(in: 0...2)
        name = gopherName[type]
        point = ((type * 2) + 1) * 12
    }
    
    func setAsBurrow()
    {
        name  = gopherName[3]
        point = 0
    }
}
