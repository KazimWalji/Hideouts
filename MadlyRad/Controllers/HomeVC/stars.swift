

import UIKit

class Stars: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeRamainLabel: UILabel!
    @IBOutlet var burrowButton: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    var gophers = [Gopher]()
    var score: Int = 0
    var eachTypeStatistics = ["normalGopher": 0, "tripleGopher": 0, "girlGopher": 0, "hole": 0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0...11
        {
            gophers.append(Gopher())
        }
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
        if let image = UIImage(named:"Unchecked") {
            sender.setImage(UIImage(named:"yellowstar.png"), for: .normal)
        }
        if let image = UIImage(named:"redstar") {
            sender.setImage( UIImage(named:"redstar.png"), for: .normal)
        }
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

