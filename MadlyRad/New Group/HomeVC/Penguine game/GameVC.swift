//
//  GameVC.swift
//  MadlyRad
//
//  Created by JOJO on 7/26/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit

class GameVC: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeRamainLabel: UILabel!
    @IBOutlet var burrowButton: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    var timeRemain = 30.0
    var timer = Timer()
    var updateStateTimer = Timer()
    var gophers = [Gopher]()
    var score: Int = 0
    var eachTypeStatistics = ["normalGopher": 0, "tripleGopher": 0, "girlGopher": 0, "hole": 0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // initial gophers
        for _ in 0...11
        {
            gophers.append(Gopher())
        }
    }
    
    @objc func countdown()
    {
        timeRemain -= 0.01
        timeRamainLabel.text = String(format: "%.2f", self.timeRemain)
        if timeRemain < 0.001 // time's up
        {
            timer.invalidate()
            updateStateTimer.invalidate()
            for i in 0...11
            {
                gophers[i].setAsBurrow()
                burrowButton[i].setImage(UIImage(named: gophers[i].getName()), for: .normal)
            }
            
            let controller = UIAlertController(title: "Time's Up!", message: "Your score is " + String(score) + ".", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultVC") as? ResultVC
                vc?.eachTypeStatistics = self.eachTypeStatistics
                vc?.score = self.score
                self.navigationController?.pushViewController(vc!, animated: true)
                print("work")
            }
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            print("work3")
        }
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        startButton.isHidden = true
        startButton.isEnabled = false
        score = 0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameVC.countdown), userInfo: nil, repeats: true)
        updateStateTimer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(GameVC.updateAllState), userInfo: nil, repeats: true)
    }
    
    @objc func updateAllState()
    {
        var nextState = [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0];
        nextState.shuffle()
        for i in 0...11{
            if nextState[i] == 1
            {
                gophers[i].randomChangeType()
            }
            else if nextState[i] == 0
            {
                gophers[i].setAsBurrow()
            }
            
            burrowButton[i].setImage(UIImage(named: gophers[i].getName()), for: .normal)
        }
    }
    
    func clickToUpdate(_ index: Int)
    {
        score += gophers[index].getPoint()
        scoreLabel.text = String(score)
        eachTypeStatistics[gophers[index].getName()] = eachTypeStatistics[gophers[index].getName()]! + 1
        gophers[index].setAsBurrow()
        burrowButton[index].setImage(UIImage(named: gophers[index].getName()), for: .normal)
    }
    
    // button name with burrow position in matrix form respectively
    @IBAction func burrow1_1(_ sender: UIButton) {
        clickToUpdate(0)
    }
    
    @IBAction func burrow1_2(_ sender: UIButton) {
        clickToUpdate(1)
    }
    
    @IBAction func burrow1_3(_ sender: UIButton) {
        clickToUpdate(2)
    }
    
    @IBAction func burrow2_1(_ sender: UIButton) {
        clickToUpdate(3)
    }
    
    @IBAction func burrow2_2(_ sender: UIButton) {
        clickToUpdate(4)
    }
    
    @IBAction func burrow2_3(_ sender: UIButton) {
        clickToUpdate(5)
    }
    
    @IBAction func burrow3_1(_ sender: UIButton) {
        clickToUpdate(6)
    }
    
    @IBAction func burrow3_2(_ sender: UIButton) {
        clickToUpdate(7)
    }
    
    @IBAction func burrow3_3(_ sender: UIButton) {
        clickToUpdate(8)
    }
    
    @IBAction func burrow4_1(_ sender: UIButton) {
        clickToUpdate(9)
    }
    
    @IBAction func burrow4_2(_ sender: UIButton) {
        clickToUpdate(10)
    }
    
    @IBAction func burrow4_3(_ sender: UIButton) {
        clickToUpdate(11)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
