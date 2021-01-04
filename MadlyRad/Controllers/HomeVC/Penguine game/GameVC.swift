import UIKit
import Foundation
class GameVC: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeRamainLabel: UILabel!
    @IBOutlet var burrowButton: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    //@IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var targetScore: UILabel!
    //let progress = Progress(totalUnitCount: 1000)
    
    var time = 0.0
    var tenSec = 10.0
    var timer = Timer()
    var countDownTimer = Timer()
    var updateStateTimer = Timer()
    var timeBetweenRefresh = 2.0
    var gophers = [Gopher]()
    var score: Int = 0
    var health: Int = 5
    var eachTypeStatistics = ["normalGopher": 0, "tripleGopher": 0, "girlGopher": 0, "hole": 0]
    var healthTimer: Timer?
    var prevScore: Int = 0
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        // initial gophers
        for _ in 0...11
        {
            gophers.append(Gopher())
        }
    }
    
     @objc func healthDown() {
          
        scoreLabel.text = String(score)
        healthLabel.text = String(health)
        prevScore += 600
        print(prevScore)
        targetScore.text = String(prevScore)
        if prevScore >= score {
            health -= 1
        }
        
    }
    
    @objc func tenSecCountDown() {
        tenSec -= 0.01
        if tenSec <= 0{
            tenSec = 10.0
            updateStateTimer.invalidate()
            timeBetweenRefresh -= 0.5
            if timeBetweenRefresh <= 1{
                timeBetweenRefresh = 1
            }
            updateStateTimer = Timer.scheduledTimer(timeInterval: timeBetweenRefresh, target: self, selector: #selector(GameVC.updateAllState), userInfo: nil, repeats: true)
        }
    }
    @objc func count()
    {
        time += 0.01
        timeRamainLabel.text = String(format: "%.2f", self.time)
        if health == 0 // health ran out
        {
            timer.invalidate()
            updateStateTimer.invalidate()
            countDownTimer.invalidate()
            healthTimer?.invalidate()
            for i in 0...11
            {
                gophers[i].setAsBurrow()
                burrowButton[i].setImage(UIImage(named: gophers[i].getName()), for: .normal)
            }
            
            let controller = UIAlertController(title: "Game Over!", message: "Your score is " + String(score) + ".", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "ResultVC") as? ResultVC
                        vc?.eachTypeStatistics = self.eachTypeStatistics
                        vc?.score = self.score
                    let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
                    self.present(vc!, animated: true, completion: nil);
                }
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
        }
    }

    @IBAction func startButtonAction(_ sender: Any) {
        startButton.isHidden = true
        startButton.isEnabled = false
        score = 0
        updateStateTimer = Timer.scheduledTimer(timeInterval: timeBetweenRefresh, target: self, selector: #selector(GameVC.updateAllState), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameVC.count), userInfo: nil, repeats: true)
        countDownTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameVC.tenSecCountDown), userInfo: nil, repeats: true)
        healthTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(healthDown), userInfo: nil, repeats: true)
        
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
    
    @objc func clickToUpdate(_ index: Int)
    {
        score += gophers[index].getPoint()
        scoreLabel.text = String(score)
        healthLabel.text = String(health)
        targetScore.text = String(prevScore)
        
        //progress bar
//        progress.completedUnitCount += Int64(gophers[index].getPoint())
        //let progressFloat = Float(progress.fractionCompleted)
        //progressView.setProgress(progressFloat, animated: true)
                
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
}
