


import UIKit
import SafariServices

class Welcome: UIViewController {

    @IBOutlet weak var gopherImageView: UIImageView!
    @IBOutlet weak var hammerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBAction func backButton(_ sender: Any) {
        let loadVC = ChatTabBar()
        loadVC.modalPresentationStyle = .fullScreen
        self.present(loadVC, animated: true, completion: nil)
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // hide navigation bar
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // poistion initialization
        //gopherImageView.center = CGPoint(x: gopherImageView.center.x, y: 960)
        //titleLabel.center = CGPoint(x: -169, y: titleLabel.center.y)
        playButton.center = CGPoint(x: 512, y: playButton.center.y)
        
        
        // title animation
       // UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.65, delay: 0, animations: {self.titleLabel.center = CGPoint(x: 207, y: self.titleLabel.center.y)})
        
        // button animation
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.65, delay: 0, animations: {self.playButton.center = CGPoint(x: 207, y: self.playButton.center.y)})
        
        
        // gopher animation
        //UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75, delay: 0, animations: {self.gopherImageView.center = CGPoint(x: self.gopherImageView.center.x, y: 791)})
        
        // hammer animation
        //UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0.75, animations: {
            //self.hammerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-30))
       // })
       // UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 1.35, animations: {
         //   self.hammerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(75))
      //  })
       let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
                edgePan.edges = .left

                view.addGestureRecognizer(edgePan)
            }

            @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
                if recognizer.state == .recognized {
                    let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeVC")
                    self.present(controller, animated: false, completion: nil)
                }
            }
        

    @IBAction func playButton(_ sender: Any) {
    

    }
    

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


