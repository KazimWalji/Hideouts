//
//  NameTextField.swift
//  MadlyRad
//
//  Created by JOJO on 9/29/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//
import SkyFloatingLabelTextField
import UIKit

class NameTextField: UIView {
    var controller: SignUpVC!
    var nameTextField = SkyFloatingLabelTextField()
    var errorLabel = UILabel()
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ controller: SignUpVC) {
        super.init(frame: .zero)
        self.controller = controller
        setupRegisterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupRegisterView() {
        controller.view.addSubview(self)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        var height: CGFloat = 300
        if controller.view.frame.height > 1000 { height = 642 }
        let constraints = [
            bottomAnchor.constraint(equalTo: controller.view.bottomAnchor, constant: -150),
            leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 32),
            trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -32),
            heightAnchor.constraint(equalToConstant: height)
        ]
        NSLayoutConstraint.activate(constraints)
        let timer = Timer(timeInterval: 0.2, target: self, selector: #selector(animateSignUpViews), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .default)
        setupSignUpLabel()
        setupNameTextField()
        setupErrorLabel()
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupSignUpLabel() {
        let signUpLabel = UILabel()
        addSubview(signUpLabel)
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.text = "SIGN UP"
        signUpLabel.textAlignment = .center
        signUpLabel.font = UIFont.boldSystemFont(ofSize: 18)
        signUpLabel.textColor = .gray
        let constraints = [
            signUpLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
        signUpLabel.alpha = 0
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupNameTextField() {
        addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Name"
        nameTextField.delegate = controller
        nameTextField.font = UIFont(name: "Alata", size: 18)
        nameTextField.selectedLineColor = ThemeColors.mainColor
        nameTextField.lineColor = .lightGray
        nameTextField.autocorrectionType = .no
        nameTextField.textContentType = .oneTimeCode
        let constraints = [
            nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 48),
            nameTextField.widthAnchor.constraint(equalToConstant: controller.view.frame.width - 120)
        ]
        NSLayoutConstraint.activate(constraints)
        nameTextField.alpha = 0
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    

    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //



    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupErrorLabel() {
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        let constraints = [
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    var setupNameshit: String?{
        return nameTextField.text
    }


}
