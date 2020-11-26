//
//  ProfileVm.swift
//  MadlyRad
//
//  Created by JOJO on 7/24/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//


import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
