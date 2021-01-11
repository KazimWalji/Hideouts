//
//  PartnershipsPage.swift
//  MadlyRad
//
//  Created by JOJO on 7/29/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import SafariServices

class PartnershipsPage: UIViewController {

    @IBAction func watchButtonTapped(_ sender: Any) {
        showSafariVC(for: "https://twitter.com/i/status/1222200082839285761")
    }
    //Girls Longboard Crew Ex
    //copy and paste the above lines of code and change the name of the button and URL
    @IBAction func partnerWebsiteButtonTapped(_ sender: Any) {
        showSafariVC(for: "https://longboardgirlscrew.com/")
    }
    //Girls Longboard Crew Ex

    @IBAction func partnerInstagramButtonTapped(_ sender: Any) {
        showSafariVC(for: "https://www.instagram.com/longboardgirlscrew/?hl=en")
    }
    //Girls Longboard Crew Ex

    @IBAction func partnerFacebookButtonTapped(_ sender: Any) {
        showSafariVC(for: "https://www.facebook.com/longboardgc/")
    }
    //Girls Longboard Crew Ex

    @IBAction func partnerTwitterButtonTapped(_ sender: Any) {
    showSafariVC(for: "https://twitter.com/longboardgirls?lang=en")
    }
    //Girls Longboard Crew Ex

    @IBAction func secondWatchButtonTapped(_ sender: Any) {
    showSafariVC(for: "https://www.youtube.com/watch?v=4Ss96VZlIyU")
    }
    //broad button naming for next partner's name and social information
    //change links of "second" buttons and change names of "second" buttons
    
    @IBAction func secondPartnerWebsiteButtonTapped(_ sender: Any) {
           showSafariVC(for: "https://www.youtube.com/watch?v=4Ss96VZlIyU")
    }
    @IBAction func secondPartnerInstagramButtonTapped(_ sender: Any) {
        showSafariVC(for: "https://www.youtube.com/watch?v=4Ss96VZlIyU")
    }

    @IBAction func secondpartnerFacebookButtonTapped(_ sender: Any) {
        showSafariVC(for: "https://www.youtube.com/watch?v=4Ss96VZlIyU")
    }
    
    @IBAction func secondpartnerTwitterButtonTapped(_ sender: Any) {
    showSafariVC(for: "https://www.youtube.com/watch?v=4Ss96VZlIyU")
    }
    
    @IBAction func thirdWatchButtonTapped(_ sender: Any) {
    showSafariVC(for: "https://www.youtube.com/watch?v=4Ss96VZlIyU")
    }
    
    @IBAction func thirdPartnerWebsiteButtonTapped(_ sender: Any) {
           showSafariVC(for: "https://www.youtube.com/watch?v=4Ss96VZlIyU")
    }
    
    @IBAction func thirdPartnerInstagramButtonTapped(_ sender: Any) {
        showSafariVC(for: "https://www.youtube.com/watch?v=4Ss96VZlIyU")
    }
    
    @IBAction func thirdPartnerFacebookButtonTapped(_ sender: Any) {
        showSafariVC(for: "https://www.youtube.com/watch?v=4Ss96VZlIyU")
    }
    
    @IBAction func thirdPartnerTwitterButtonTapped(_ sender: Any) {
    showSafariVC(for: "https://www.youtube.com/watch?v=4Ss96VZlIyU")
    }
    

    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
      let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
}
