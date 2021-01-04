//
//  StickerCellViewController.swift
//  MadlyRad
//
//  Created by JOJO on 8/22/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import Kingfisher

class StickersCell: UICollectionViewCell {

    @IBOutlet var imageItem: UIImageView!
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func bindData(sticker: String) {

        let url = URL(string: sticker)
        imageItem.kf.setImage(with: url, placeholder: nil)
    }
  

}
