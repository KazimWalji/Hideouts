//
//  LocalStoreImagesService.swift
//  MadlyRad
//
//  Created by THXDBase on 31.08.2020.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit

final class LocalStoreImagesService {
    func load(id: String, completion:@escaping(UIImage?)->()) {
        let path = imagePath(id)
        let imageURL = URL(fileURLWithPath: path)
        if FileManager.default.fileExists(atPath: path),
            let imageData: Data = try? Data(contentsOf: imageURL),
            let image: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) {
            completion(image)
            return
        }
        completion(nil)
    }
    
    func cacheImage(image: UIImage, id: String) {
        let path = imagePath(id)
        let imageURL = URL(fileURLWithPath: path)
        do {
            try image.pngData()?.write(to: imageURL)
        } catch let error {
            print("Saving photo failed: ", error.localizedDescription)
        }
    }
    
    private func imagePath(_ id: String) -> String {
        return "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(id).png"
    }
}
