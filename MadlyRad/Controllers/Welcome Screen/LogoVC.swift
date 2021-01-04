

import UIKit
import Lottie

class LogoVC: UIViewController {
        
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // LogoVC appears when user opens the app. It serves as a networking view.
    
    var animationView = AnimationView()
    var logoImage = UIImageView()
    var logoLabel = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // let gradient = setupGradientLayer()
      //  gradient.frame = view.frame
        //view.layer.insertSublayer(gradient, at: 0)
    //background
        view.backgroundColor = .white

      //  setupLogo()
    //    setupLogoLabel()
        setupAnimationView()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    private func buttonClicked(){
        
    }
    private func setupLogo(){
        view.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.image = UIImage(named: "Logo-Light")
        logoImage.layer.cornerRadius = 75
        logoImage.layer.masksToBounds = true
        let constraints = [
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 150),
            logoImage.widthAnchor.constraint(equalToConstant: 150),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.midY/4)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLogoLabel() {
        view.addSubview(logoLabel)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.text = "Hideouts"
        logoLabel.font = UIFont.boldSystemFont(ofSize: 32)
        logoLabel.textColor = .black
        let constraints =  [
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupAnimationView() {
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.animation = Animation.named("loading")
        animationView.loopMode = .loop
        animationView.play()
        let constraints = [
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            //animationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            //animationView.heightAnchor.constraint(equalToConstant: 100),
          //  animationView.widthAnchor.constraint(equalToConstant: 100),
        ]
        NSLayoutConstraint.activate(constraints)
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

