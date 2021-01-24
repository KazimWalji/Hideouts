
import UIKit
import SafariServices

class SignUpVC: UIViewController, UITextFieldDelegate, SFSafariViewControllerDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // SignUpVC. The first controller that users see in a registration process.
    
    var signInVC: SignInVC!
    var backButton: AuthBackButton!
    private let signUpView = SignUpView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var authNetworking: AuthNetworking!
    var authKeyboardHandler = AuthKeyboardHandler()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       //background
        view.backgroundColor = .white
        authKeyboardHandler.view = view
        authKeyboardHandler.notificationCenterHandler()
        HideoutsLabel()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUI() {
        view.backgroundColor = .white
        //setupGradientView()
        setupRegisterView()
        setupContinueButton()
        setupBackButton()
        UserProtectionsButton()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    private func HideoutsLabel(){
        let yourLabel: UILabel = UILabel()
        yourLabel.frame = CGRect(x: self.view.center.x, y: 130, width: 225, height: 100)
        yourLabel.center.x = self.view.center.x
        yourLabel.textColor = ThemeColors.mainColor
        yourLabel.textAlignment = NSTextAlignment.center
        yourLabel.text = "HIDEOUTS"
        yourLabel.font = UIFont(name: "Helvetica-Bold", size: 40)
        self.view.addSubview(yourLabel)
    }
    private func setupGradientView() {
        let _ = GradientLogoView(self, true)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupRegisterView() {
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(signUpView)
        
        NSLayoutConstraint.activate([
            signUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        signUpView.textFieldDelegate = self
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    private func UserProtectionsButton(){
        let caution = UIButton()
        self.view.addSubview(caution)
        caution.translatesAutoresizingMaskIntoConstraints = false
        caution.center.x = self.view.center.x
        caution.titleLabel?.numberOfLines = 0
        caution.titleLabel?.textColor = ThemeColors.mainColor
        caution.titleLabel?.textAlignment = NSTextAlignment.center
        caution.setTitle("By continuing, you are agree to the terms and conditions", for: .normal)
        caution.setTitleColor(ThemeColors.mainColor, for: .normal)
        caution.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 12)
        caution.addTarget(self, action: #selector(termsAndCondtions), for: .touchUpInside)
        let constraints = [
            caution.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            caution.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -50),
            caution.heightAnchor.constraint(equalToConstant: 50),
            caution.widthAnchor.constraint(equalToConstant: 350)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }

    private func setupContinueButton() {
        signUpView.continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupBackButton() {
        backButton = AuthBackButton(self)
        backButton.alpha = 0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.tintColor = ThemeColors.mainColor
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func backButtonPressed() {
        dismiss(animated: false) {
            self.signInVC.returnToSignInVC()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: TEXTFIELD VALIDATION
    
    private func validateTF() -> String? {
        if signUpView.nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || signUpView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || signUpView.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || signUpView.userIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Make sure you fill in all fields."
        }
        
        let password = signUpView.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = signUpView.nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = signUpView.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let UserID = signUpView.userIDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.count < 6 {
            return "Password should be at least 6 characters long."
        }
    
        if name.count > 30 {
            return "Your name exceeds a limit of 30 characters."
        }
        
        if email.count > 30 {
            return "Your email exceeds a limit of 30 characters."
        }
        if UserID.count > 30 {
            return "Your Username exceeds the limit"
        }
        
        if !email.isValidEmail {
            return "Wrong email address format."
        }
        
        return nil
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: SIGN UP METHOD.
    @objc private func termsAndCondtions() {
        let urlString = "https://madlyradlabs.com/madlyrad-_-terms-of-service/"

        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self

            present(vc, animated: true)
        }
    }
    
    @objc private func continueButtonPressed() {
        if signUpView.isHidden == true{
            signUpView.isHidden = false
            signUpView.nameTextField.isHidden = true
            return
        }
        
        signUpView.errorLabel.text = ""
        let validation = validateTF()
        if validation != nil {
            signUpView.errorLabel.text = validation
            return
        }
        let email = signUpView.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        authNetworking = AuthNetworking(self)
        authNetworking.checkForExistingEmail(email) { (errorMessage) in
            guard errorMessage == nil else {
                self.signUpView.errorLabel.text = errorMessage
                return
            }
        }
        let UserID = signUpView.userIDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        authNetworking = AuthNetworking(self)
        authNetworking.checkForExistingUserID(with: UserID) { (errorMessage) in
            guard errorMessage == nil else {
                self.signUpView.errorLabel.text = errorMessage
                return
            }
            self.goToNextController()
        }
    }

    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: NEXT CONTROLLER METHOD
    
    private func goToNextController(){
        guard let name = signUpView.nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let email = signUpView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = signUpView.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let UserID = signUpView.userIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let pronoun = signUpView.pronounTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            // TODO: warn user
            return
        }
        let controller = SelectProfileImageVC()
        controller.modalPresentationStyle = .fullScreen
        controller.name = name
        controller.email = email
        controller.password = password
        controller.UserID = UserID
        controller.pronoun = pronoun
        self.show(controller, sender: nil)
    }
}
