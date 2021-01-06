//
//  BellNotificationView.swift
//  MadlyRad
//
//  Created by Alex Titov on 1/6/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct Notification {
    var id: Int
    var name: String
    var status: String
    var avatar: String
}

struct NotificationView: View {
    
    var notifications: [Notification] = [
        Notification(id: 0, name: "Alex", status: "I will be on in 10 minutes!", avatar: "Dinosaur"),
        Notification(id: 1, name: "John", status: "I won't be on for a while.", avatar: "Dinosaur"),
        Notification(id: 2, name: "Emily", status: "I won't be on for a while.", avatar: "Dinosaur"),
        Notification(id: 3, name: "Dinosaur", status: "I will be on in 10 minutes!", avatar: "Dinosaur")
    ]
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(notifications, id: \.id) { notification in
                    HStack {
                        Image(notification.avatar)
                            .resizable()
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                            .clipped()
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text(notification.name)
                        Text(notification.status)
                    }
                }.navigationBarTitle("Notifications")
            }
        }
    }
    
    
}
