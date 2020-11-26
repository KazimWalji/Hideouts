//
//  Data.swift
//  MadlyRad
//
//  Created by JOJO on 7/26/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import Foundation

extension Date {
    
    static func fromStringToDate(input: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: input) {
            return date
        }
        return Date()
    }
    
    static func fromDateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let retString = dateFormatter.string(from: date)
        return retString
    }
    
} 
