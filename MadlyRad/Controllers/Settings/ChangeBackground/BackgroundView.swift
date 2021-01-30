//
//  BackgroundView.swift
//  MadlyRad
//
//  Created by Alex Titov on 1/30/21.
//  Copyright © 2021 MadlyRad. All rights reserved.
//

import UIKit

struct BackgroundView {
    var view: UIView
    var background: UIImageView
    
    init(frame: CGRect, image: UIImage) {
        view = UIView(frame: frame)
        background = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        background.image = image
        view.addSubview(background)
    }
}
