//
//  SettingsCelll.swift
//  Login Screen
//
//  Created by Harrison Leath on 6/29/18.
//  Copyright © 2018 Harrison Leath. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    let iconView = UIImageView()
    let labelText = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconView)
        contentView.addSubview(labelText)
        
        //temporary placeholder image
        iconView.image = UIImage(named: "defaultPI")
        iconView.layer.cornerRadius = 16
        iconView.layer.masksToBounds = true
        iconView.contentMode = .scaleAspectFill
        iconView.translatesAutoresizingMaskIntoConstraints = false
    
        labelText.translatesAutoresizingMaskIntoConstraints = false

        iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        labelText.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 10).isActive = true
        labelText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        labelText.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10).isActive = true
        labelText.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
