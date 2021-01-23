//
//  TermsAndConditions.swift
//  MadlyRad
//
//  Created by JOJO on 7/27/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class TermsAndConditions: UIViewController {
    @IBAction func button_ShareClick(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems:["www.hideoutsusa.com"], applicationActivities:nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC,animated:true,completion:nil)
    }


    @IBAction func work(_ sender: Any) {
        
    
    showSafariVC(for: "https://madlyradlabs.com/madlyrad-_-terms-of-service/")
    }
    

    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
      let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

