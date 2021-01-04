//
//  terms+conditions.swift
//  MadlyRad
//
//  Created by JOJO on 8/1/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import SafariServices
class TermsconditionsVC: UIViewController {
    
    
    @IBAction func TermsAndConditions(_ sender: Any) {
   showSafariVC(for: "https://madlyradlabs.com/madlyrad-_-terms-of-service/")
   }
    @IBAction func Privacy(_ sender: Any) {
    showSafariVC(for: "https://madlyradlabs.com/madlyrad-_-privacy-policy/")
    }
    @IBAction func Website(_ sender: Any) {
    showSafariVC(for: "https://hideoutsusa.com/")
    }


func showSafariVC(for url: String) {
    guard let url = URL(string: url) else {
        return
    }
  let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
