

import UIKit
import SkyFloatingLabelTextField

class SignUpView: UIView {
    
    private let backgroundView = UIView(frame: .zero)
    let continueButton = AuthActionButton("CONTINUE")
    let nameTextField = SkyFloatingLabelTextField()
    let emailTextField = SkyFloatingLabelTextField()
    let passwordTextField = SkyFloatingLabelTextField()
    let pronounTextField = SkyFloatingLabelTextField()
    let userIDTextField = SkyFloatingLabelTextField()
    let errorLabel = UILabel()
    
    private let textFieldsStackView = UIStackView(frame: .zero)
    
    var textFieldDelegate: UITextFieldDelegate? {
        get {
            return nameTextField.delegate
        }
        
        set {
            [nameTextField,
             emailTextField,
             passwordTextField,
             userIDTextField,
             pronounTextField].forEach { $0.delegate = newValue}
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        setupContinueButton()
        setupBackgroundView()
        
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupUserIDTextField()
        setupPronounTextField()
        
        setupFieldsStackView(fieldViews: [nameTextField,
                                          userIDTextField,
                                          pronounTextField,
                                          emailTextField,
                                          passwordTextField,
        ])
        //hurrr: commented
//        let timer = Timer(timeInterval: 0.2, target: self, selector: #selector(animateSignUpViews), userInfo: nil, repeats: false)
//        RunLoop.current.add(timer, forMode: .default)
        setupSignUpLabel()
        setupErrorLabel()
    }
    
    private func setupFieldsStackView(fieldViews: [UIView]) {
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalMargin = CGFloat(48)
        let horizontalMargin = CGFloat(28)
        
        addSubview(textFieldsStackView)
        NSLayoutConstraint.activate([
            textFieldsStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: verticalMargin),
            textFieldsStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -verticalMargin),
            textFieldsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: horizontalMargin),
            textFieldsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -horizontalMargin),
        ])
        
        textFieldsStackView.axis = .vertical
        fieldViews.forEach {
            textFieldsStackView.addArrangedSubview($0)
        }
    }
    
    private func setupContinueButton() {
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(continueButton)
        let constraints = NSLayoutConstraint.activate([
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func setupBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        
        let shadowRadius = CGFloat(10)
        backgroundView.layer.cornerRadius = 8
        backgroundView.layer.shadowRadius = shadowRadius
        backgroundView.layer.shadowOpacity = 0.3
        
        insertSubview(backgroundView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            backgroundView.bottomAnchor.constraint(equalTo: continueButton.centerYAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: shadowRadius),
        ])
    }
    
    func setupSignUpLabel() {
        let signUpLabel = UILabel()
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(signUpLabel)
        signUpLabel.text = "SIGN UP"
        signUpLabel.textAlignment = .center
        signUpLabel.font = UIFont.boldSystemFont(ofSize: 18)
        signUpLabel.textColor = .gray
        let constraints = [
            signUpLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
        signUpLabel.alpha = 1
    }
    
    func setupNameTextField() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextField.placeholder = "Name"
        nameTextField.font = UIFont(name: "Alata", size: 18)
        nameTextField.selectedLineColor = ThemeColors.mainColor
        nameTextField.lineColor = .lightGray
        nameTextField.autocorrectionType = .no
        nameTextField.textContentType = .oneTimeCode
        nameTextField.alpha = 1
    }
    
    func setupEmailTextField() {
//        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        emailTextField.font = UIFont(name: "Alata", size: 18)
        emailTextField.selectedLineColor = ThemeColors.mainColor
        emailTextField.lineColor = .lightGray
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.textContentType = .oneTimeCode
        emailTextField.alpha = 1
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    func setupUserIDTextField() {
//        userIDTextField.translatesAutoresizingMaskIntoConstraints = false
        userIDTextField.placeholder = "User Name"
        userIDTextField.font = UIFont(name: "Alata", size: 18)
        userIDTextField.selectedLineColor = ThemeColors.mainColor
        userIDTextField.lineColor = .lightGray
        userIDTextField.autocapitalizationType = .none
        userIDTextField.autocorrectionType = .no
        userIDTextField.textContentType = .oneTimeCode
        emailTextField.alpha = 1
    }
    
    func setupPronounTextField() {
//        pronounTextField.translatesAutoresizingMaskIntoConstraints = false
        pronounTextField.placeholder = "Pronouns"
        pronounTextField.font = UIFont(name: "Alata", size: 18)
        pronounTextField.selectedLineColor = ThemeColors.mainColor
        pronounTextField.lineColor = .lightGray
        pronounTextField.autocorrectionType = .no
        pronounTextField.autocapitalizationType = .none
        pronounTextField.isSecureTextEntry = false
        pronounTextField.textContentType = .name
        pronounTextField.alpha = 1
    }
    
    func setupPasswordTextField() {
//        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont(name: "Alata", size: 18)
        passwordTextField.selectedLineColor = ThemeColors.mainColor
        passwordTextField.lineColor = .lightGray
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.alpha = 1 //hurrr: changed from 0 to 1
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        addSubview(errorLabel)
        let constraints = [
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
// TODO: integrate animation
/*
    @objc func animateSignUpViews() {
        for registerView in subviews {
            registerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        controller.backButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        controller.continueButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            for registerView in self.subviews {
                registerView.alpha = 1
                registerView.transform = .identity
            }
            self.controller.backButton.transform = .identity
            self.controller.continueButton.transform = .identity
            self.controller.backButton.alpha = 1
            self.controller.continueButton.alpha = 1
        })
    }
 */
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    var setupNameshit: String?{
        return nameTextField.text
    }
    
}
