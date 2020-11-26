//
//  plswork.swift
//  MadlyRad
//
//  Created by JOJO on 7/26/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import Foundation
import UIKit

class DiscussionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    private var _discussion = Discussion.init()
    var discussion: Discussion {
        get{
            return _discussion
        }
        set{
            _discussion = newValue
            titleLabel.text = _discussion.title
            lastMessageLabel.text = _discussion.lastMessage
        }
    }
    
}
