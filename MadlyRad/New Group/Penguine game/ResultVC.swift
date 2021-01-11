//
//  ResultsVC.swift
//  MadlyRad
//
//  Created by JOJO on 7/26/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {

    @IBOutlet weak var numberOfNormalLabel: UILabel!
    @IBOutlet weak var numberOfTripleLabel: UILabel!
    @IBOutlet weak var numberOfGirlLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    var eachTypeStatistics: [String: Int]!
    var score: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        numberOfNormalLabel.text = String(eachTypeStatistics["normalGopher"]!)
        numberOfTripleLabel.text = String(eachTypeStatistics["tripleGopher"]!)
        numberOfGirlLabel.text = String(eachTypeStatistics["girlGopher"]!)
        ScoreLabel.text = String(score!)
       // updateLeaderboard()
    }
    
    @IBAction func homeButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
