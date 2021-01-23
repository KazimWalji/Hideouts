
import UIKit

class ResultVC: UIViewController {

    @IBOutlet weak var numberOfNormalLabel: UILabel!
    @IBOutlet weak var numberOfTripleLabel: UILabel!
    @IBOutlet weak var numberOfGirlLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var HighestScoreLabel: UILabel!
    
    var eachTypeStatistics: [String: Int]!
    var score: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        numberOfNormalLabel.text = String(eachTypeStatistics["normalGopher"]!)
        numberOfTripleLabel.text = String(eachTypeStatistics["tripleGopher"]!)
        numberOfGirlLabel.text = String(eachTypeStatistics["girlGopher"]!)
        
        var highScoreDefault = UserDefaults.standard
        var highestScore = highScoreDefault.integer(forKey: "hScore")
        
        if highestScore == nil {
            highestScore = score
            highScoreDefault.setValue(highestScore, forKey: "hScore")
            highScoreDefault.synchronize()
        }
        if score > highestScore {
            highestScore = score
            highScoreDefault.setValue(highestScore, forKey: "hScore")
            highScoreDefault.synchronize()
            
            highestScore = highScoreDefault.value(forKey: "hScore") as! Int
            HighestScoreLabel.text = String(highestScore)
        } else {
            highestScore = highScoreDefault.value(forKey: "hScore") as! Int
            HighestScoreLabel.text = String(highestScore)
        }
        
        ScoreLabel.text = String(score!)
       // updateLeaderboard()
    }
    
    

    
    @IBAction func homeButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as? Welcome
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func exit(unwindSegue: UIStoryboardSegue) {
        let controller = ChatTabBar()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)


    }
    
}
