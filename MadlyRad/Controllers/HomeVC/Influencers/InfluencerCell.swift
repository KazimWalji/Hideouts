//
//  InfluencerCell.swift
//  MadlyRad
//
//  Created by THXDBase on 12.10.2020.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit

class InfluencerCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var infImageView: UIImageView!
    @IBOutlet weak var infNameLabel: UILabel!
    @IBOutlet weak var infShortLabel: UILabel!
    @IBOutlet weak var infButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 5
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowRadius = 4
        
//        layer.backgroundColor = UIColor.clear.cgColor
    }
    
    
    
    var onButtonClicked: ((InfluencerData?) -> Void)?
    
    var data: InfluencerData? {
        didSet{
            guard data != nil else { return }
            infImageView.image = UIImage(named: data!.image)
            infNameLabel.text = data!.name
            infShortLabel.text = data!.shortInfo
            
        }
    }

    @IBAction func onButtonHandler(_ sender: Any) {
        onButtonClicked?(data)
    }
    
}
