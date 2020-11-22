

import UIKit
import FirebaseAuth
//we protect your privacy; we only collect your email and never share or sell your information
class SignInVC: UIViewController, UITextFieldDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // SignInVC. This controller is responsible for authenticating users that are already in the database.
    
    var authNetworking: AuthNetworking!
    var authKeyboardHandler = AuthKeyboardHandler()
    var loginView: SignInView!
    var loginButton: AuthActionButton!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //background
        view.backgroundColor = .white
        HideoutsLabel()
        setupUI()
        authKeyboardHandler.view = view
        authKeyboardHandler.notificationCenterHandler()
        forgotPassword()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    private func HideoutsLabel(){
        let yourLabel: UILabel = UILabel()
        yourLabel.frame = CGRect(x: self.view.center.x, y: 150, width: 225, height: 100)
        yourLabel.center.x = self.view.center.x
        yourLabel.textColor = ThemeColors.mainColor
        yourLabel.textAlignment = NSTextAlignment.center
        yourLabel.text = "HIDEOUTS"
        yourLabel.font = UIFont(name: "Helvetica-Bold", size: 40)
        self.view.addSubview(yourLabel)
    }
    private func setupUI(){
        view.backgroundColor = .white
       // let _ = GradientLogoView(self, false)
        loginView = SignInView(self)
      //  let _ = SignInLogoAnimation(self)
        setupLoginButton()
        setupSignUpButton()
        UserProtectionsLabe()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: TEXTFIELD VALIDATION
    
    private func validateTF() -> String?{
        if loginView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || loginView.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Make sure you fill in all fields"
        }
        
        let password = loginView.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.count < 6 {
            return "Password should be at least 6 characters long"
        }
        return nil
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLoginButton() {
        loginButton = AuthActionButton("SIGN IN", self)
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        let constraints = [
            loginButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: loginView.bottomAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    private func UserProtectionsLabe(){
        let caution: UILabel = UILabel()
        caution.translatesAutoresizingMaskIntoConstraints = false
        caution.numberOfLines = 0
        caution.center.x = self.view.center.x
        caution.textColor = ThemeColors.mainColor
        caution.textAlignment = NSTextAlignment.center
        caution.text = "We protect your privacy; we only collect your email and never share or sell your information"
        caution.font = UIFont(name: "Helvetica-Bold", size: 12)
        self.view.addSubview(caution)
        let constraints = [
            caution.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            caution.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 50),
            caution.heightAnchor.constraint(equalToConstant: 50),
            caution.widthAnchor.constraint(equalToConstant: 350)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupSignUpButton() {
        let signUpButton = UIButton(type: .system)
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        let mainString = "Don't have an account? Sign Up"
        let stringWithColor = "Sign Up"
        let range = (mainString as NSString).range(of: stringWithColor)
        let attributedString = NSMutableAttributedString(string: mainString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range)
        signUpButton.setAttributedTitle(attributedString, for: .normal)
        signUpButton.tintColor = .black
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        let constraints = [
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func forgotPassword() {
        let signUpButton = UIButton(type: .system)
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        let mainString = "Forgot Password?"
        let stringWithColor = "Forgot Password?"
        let range = (mainString as NSString).range(of: stringWithColor)
        let attributedString = NSMutableAttributedString(string: mainString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range)
        signUpButton.setAttributedTitle(attributedString, for: .normal)
        signUpButton.tintColor = .black
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        signUpButton.addTarget(self, action: #selector(forgotPasswordSelected), for: .touchUpInside)
        let constraints = [
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 26),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: ANIMATION TO SIGN UP VIEW
    
    @objc private func forgotPasswordSelected() {

            let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
            forgotPasswordAlert.addTextField { (textField) in
                textField.placeholder = "Enter email address"
            }
            forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
                let resetEmail = forgotPasswordAlert.textFields?.first?.text
                Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                    if error != nil{
                        let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetFailedAlert, animated: true, completion: nil)
                    }else {
                        let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetEmailSentAlert, animated: true, completion: nil)
                    }
                })
            }))
            //PRESENT ALERT
            self.present(forgotPasswordAlert, animated: true, completion: nil)
        }


    
    @objc private func signUpButtonPressed() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            for subview in self.loginView.subviews {
                subview.alpha = 0
            }
            self.loginButton.alpha = 0
        }) { (true) in
            let controller = SignUpVC()
            controller.modalPresentationStyle = .fullScreen
            controller.signInVC = self
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: LOGIN METHOD
    
    @objc private func loginButtonPressed() {
        loginView.errorLabel.text = ""
        let validation = validateTF()
        if validation != nil {
            loginView.errorLabel.text = validation!
            return
        }
        let password = loginView.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = loginView.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        authNetworking = AuthNetworking(self)
        authNetworking.signIn(with: email, and: password) { (error) in
            self.loginView.errorLabel.text = error?.localizedDescription
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

