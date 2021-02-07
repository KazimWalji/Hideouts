
import UIKit
import SafariServices

class AboutViewController: UIViewController {
    let tableView = UITableView()
    var working: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "About"
        //view.backgroundColor = .white
        view.backgroundColor = .white
//background
        TermsAndConditions()
        About()
        privacyPolicy()
        DonateToAGoodCause()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
   

   private func TermsAndConditions() {
    let button = UIButton(frame: CGRect(x: self.view.center.x, y: 100, width: 325, height: 50))
            button.center.x = self.view.center.x
          button.setTitle("Terms and Conditions", for: .normal)
          button.addTarget(self, action: #selector(TermsAndConditionsSafari), for: .touchUpInside)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)


          self.view.addSubview(button)
        }

        @objc func TermsAndConditionsSafari(sender: UIButton!) {
          print("Button tapped")
        if let url = URL(string: "https://madlyradlabs.com/")
        {

          let safariVC = SFSafariViewController(url: url)
          present(safariVC, animated: true, completion: nil)

        }

        }
    private func About() {
        let button = UIButton(frame: CGRect(x: self.view.center.x, y: 150, width: 325, height: 50))
        button.center.x = self.view.center.x
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
          button.setTitle("About", for: .normal)
          button.addTarget(self, action: #selector(AboutAction), for: .touchUpInside)

          self.view.addSubview(button)
        }

        @objc func AboutAction(sender: UIButton!) {
          print("Button tapped")
        if let url = URL(string: "https://hideoutsusa.com/about/")
        {

          let safariVC = SFSafariViewController(url: url)
          present(safariVC, animated: true, completion: nil)

        }
            
    }
    private func privacyPolicy() {
        let button = UIButton(frame: CGRect(x: self.view.center.x, y: 200, width: 325, height: 50))
        button.center.x = self.view.center.x
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
          button.setTitle("Privacy Policy", for: .normal)
          button.addTarget(self, action: #selector(privacyPolicyAction), for: .touchUpInside)

          self.view.addSubview(button)
        }

        @objc func privacyPolicyAction(sender: UIButton!) {
          print("Button tapped")
        if let url = URL(string: "https://madlyradlabs.com/madlyrad-_-privacy-policy/")
        {

          let safariVC = SFSafariViewController(url: url)
          present(safariVC, animated: true, completion: nil)

        }
    }
    private func DonateToAGoodCause() {
    let button = UIButton(frame: CGRect(x: self.view.center.x, y: 250, width: 325, height: 50))
        button.center.x = self.view.center.x
      //button.backgroundColor = .green
      button.setTitle("Check Out Our Team!!", for: .normal)
      button.addTarget(self, action: #selector(DonateToAGoodCauseTapped), for: .touchUpInside)
    button.setTitleColor(UIColor.black, for: UIControl.State.normal)


      self.view.addSubview(button)
    }

    @objc func DonateToAGoodCauseTapped(sender: UIButton!) {
      print("Button tapped")
    if let url = URL(string: "https://hideoutsusa.com/meet-the-team/")
    {

      let safariVC = SFSafariViewController(url: url)
      present(safariVC, animated: true, completion: nil)

    }

    }

    @objc func smileNotesAction(sender: UIButton!) {
    let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "SmilesNotesViewController")
    self.present(controller, animated: false, completion: nil)
        controller.modalPresentationStyle = .fullScreen

}


}

