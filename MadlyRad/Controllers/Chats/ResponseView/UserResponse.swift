

import UIKit
import ScreenShieldKit

class UserResponse {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var responseStatus = false
    
    var repliedMessage: Messages?
    
    var messageToForward: Messages?
    
    var messageSender: String?
    
    let lineView = UIView()
    
    let nameLabel = UILabel()
    
    var nameLabelConstraint: NSLayoutConstraint!
    
    let messageLabel = SSKProtectedLabel(text: "")
    
    let mediaMessage = UIImageView()
    
    let audioMessage = UILabel()
    
    let exitButton = UIButton(type: .system)
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

