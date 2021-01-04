//
//  shakingscool.swift
//  MadlyRad
//
//  Created by JOJO on 8/3/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import Foundation
import UIKit
import SAConfettiView
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class ShakingcoolVC: UIViewController, UIScrollViewDelegate  {
        @IBOutlet weak var pageControl: UIPageControl!
        @IBOutlet weak var scrollView: UIScrollView!
        var images: [String] = ["0", "1", "2"]
        var frame = CGRect(x:0, y:0, width:0, height:0)
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
            pageControl.currentPage = Int(pageNumber)
        }
    @objc fileprivate func downloadimage() {
        
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.type = .Image(UIImage(named: "tripleGopher")!)
        confettiView.type = .Image(UIImage(named: "normalGopher")!)
        confettiView.type = .Image(UIImage(named: "girlGopher")!)
        confettiView.intensity = 0.4
        view.addSubview(confettiView)
        confettiView.startConfetti()
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
        confettiView.stopConfetti()
        }
        for index in 0..<images.count {
                frame.origin.x = scrollView.frame.size.width * CGFloat(index)
                frame.size = scrollView.frame.size
                let imgView = UIImageView(frame: frame)
                imgView.image = UIImage(named: images[index])
                self.scrollView.addSubview(imgView)
            }
         scrollView.contentSize = CGSize(width:(scrollView.frame.size.width * CGFloat(images.count)), height:scrollView.frame.size.height)
            scrollView.delegate = self

        }

    
}
