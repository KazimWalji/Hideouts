

import SpriteKit
import GameplayKit
import FirebaseDatabase

class GameScene: SKScene {
    //SKScene
    var timer = Timer()
    var colorCurrent: Int?
    enum starColors{
        static let colors = [ //change colorset here.
            UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
            UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
            UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        ]
        
    }
    override func didMove(to view: SKView){
        
backgroundColor = UIColor(red: 20/255, green: 40/255, blue: 40/255, alpha: 1.0 )
        print("starts")
        displayStar()
        scheduledTimerInterval()
        humanDetection()
    }
    
    func scheduledTimerInterval() {
        let randomTime: Float = Float.random(in: 1.0...15.0)
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(randomTime), target: self, selector: #selector(GameScene.displayStar), userInfo: nil, repeats: true)
    }
    
    @objc func displayStar() {
        colorCurrent = Int(arc4random_uniform(UInt32(4)))
        let star = SKSpriteNode(texture: SKTexture(imageNamed: "star"), color:starColors.colors[colorCurrent!], size: CGSize(width: 40.0, height: 40.0) )
        
        let viewMidX = view!.bounds.midX
        let viewMidY = view!.bounds.midY
        
        let xPosition = view!.scene!.frame.midX - viewMidX + CGFloat(arc4random_uniform(UInt32(viewMidX*2)))
        let yPosition = view!.scene!.frame.midY - viewMidY + CGFloat(arc4random_uniform(UInt32(viewMidY*2)))
        
        star.position = CGPoint(x: xPosition, y: yPosition)

        star.colorBlendFactor = 1.0
        star.name = "star"
        
        addChild(star)
        print("stars")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let star = self.atPoint(positionInScene)
        let animationList = SKAction.sequence([SKAction.fadeOut(withDuration: 0.1)])


        if let name = star.name
        {
            if name == "star"
            {
                star.run(animationList)
            }
        }

    }
    
    let ref = Database.database().reference()
    var users = [FriendInfo]()
    func humanDetection() {
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.hasChild("users"){

                print("\(self.users.count)")

         }else{

             print("\(self.users.count)")
         }


     })
    }
}




/*
    /*
    @IBAction func musicSelection(_ sender: UIButton) {
        musicCollection.forEach{ (MusicBtn) in
            UIView.animate(withDuration: 0.4, animations: {
                MusicBtn.isHidden = !MusicBtn.isHidden
                
            })
        }
    }
    
    
    @IBAction func musicChoices(_ sender: UIButton) {
    }
    
    @IBOutlet var musicCollection: [UIButton]!
    @IBOutlet weak var Musicselect: UIButton!
    
    
    @IBAction func appleMusicButton(_ sender: Any) {
        let application = UIApplication.shared
        let itunesWebsiteUrl = URL(string: "https://music.apple.com")!
        application.open(itunesWebsiteUrl)
    }
    @IBAction func spotifyButton(_ sender: Any) {
        let application = UIApplication.shared
        
        let spotifyAppPath = "spotify://"
        
        let spotifyUrl = URL(string: spotifyAppPath)!
        
        let spotifyWebsiteUrl = URL(string: "https://apps.apple.com/us/app/spotify-music-and-podcasts/id324684580")!
        
        if application.canOpenURL(spotifyUrl) {
            application.open(spotifyUrl, options: [:], completionHandler: nil)
        } else{
            application.open(spotifyWebsiteUrl)
        }
    }
    @IBAction func youtubeMusicButton(_ sender: Any) {
        let application = UIApplication.shared
        let youtubeWebsiteUrl = URL(string: "https://youtube.com/")!
            application.open(youtubeWebsiteUrl, options: [:], completionHandler: nil)
    }
*/

    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel()
        //musicCollection.forEach { (MusicBtn) in MusicBtn.isHidden = true}
       // let storyboard = UIStoryboard(name: "homeVC", bundle: nil)
        //let controller = storyboard.instantiateViewController(withIdentifier: "HomeVC")
       // self.present(controller, animated: false, completion: nil);
//        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
            //  edgePan.edges = .right
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundimageforhideouts.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
      //  view.addGestureRecognizer(edgePan)
        gameButton()
        navigationItem.title = "Home"
        NotificationCenter.default.addObserver(
               forName: UIApplication.userDidTakeScreenshotNotification,
               object: nil, queue: nil) { _ in
                 print("I see what you did there")
             }

    }
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    private func gameButton(){
        let button = UIButton(type: .system)
    view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
button.setBackgroundImage(UIImage(systemName: "gamecontroller"), for: .normal)

      button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.tintColor = .purple
      self.view.addSubview(button)
    let constraints = [
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        button.widthAnchor.constraint(equalToConstant: 32),
        button.heightAnchor.constraint(equalToConstant: 32)
    ]
    NSLayoutConstraint.activate(constraints)
    }

    @objc func buttonAction(sender: UIButton!) {
      let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
      let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeVC")
      self.present(controller, animated: false, completion: nil);
    }
    /*@objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeVC")
            self.present(controller, animated: false, completion: nil);
        }
        
    }*/
    private func warningLabel(){
        let label: UILabel = UILabel()
        label.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 250, height: 100)
        label.center.x = self.view.center.x
        label.center.y = self.view.center.y
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.text = "More coming soon!"
        label.numberOfLines = 0
        self.view.addSubview(label)

    }

 }*/
