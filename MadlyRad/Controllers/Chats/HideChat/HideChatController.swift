//
//  HideChatController.swift
//  MadlyRad
//
//  Created by THXDBase on 04.09.2020.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol HideChatType: class {
    var baseView: UIView { get }
    var targetView: UIView? { get }
    func setupHideKeyboardTap(isActive:Bool)
}

final class HideChatController {
    weak var viewController: HideChatType?
    static let hideButtonHeight = CGFloat(50)
    
    lazy var hideButtonFrame: CGRect = {
        let superframe = viewController?.baseView.frame ?? UIScreen.main.bounds
        let width = superframe.width * 0.3
        let maxY = viewController?.targetView?.frame.maxY ?? superframe.height
        let y = maxY - HideChatController.hideButtonHeight - 10
        return CGRect(
            x: superframe.width / 2 - width / 2
            , y: y
            , width: width
            , height: HideChatController.hideButtonHeight)
    }()
    lazy var hideButton: RoundButton = {
        let button = RoundButton(frame: hideButtonFrame)
        button.cornerRadius = 27
        button.shadowRadius = 1
        button.borderWidth = 0
        button.shadowOpacity = 1
        button.shadowOffset = CGSize(width: 0, height: 2)
        button.shadowColor = .lightGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(hideButtonHandler), for: .touchUpInside)
        return button
    }()
    
    fileprivate static let key = "hideChatState_isHidden"
    private let titleForHiddenState = "Show Chat"
    private let titleForShownState = "Hide Chat"
    
    var isHidden: Bool {
        get{
            return UserDefaults.standard.bool(forKey: HideChatController.key)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: HideChatController.key)
        }
    }

    init(viewController: HideChatType) {
        self.viewController = viewController
    }
    
    func setup() {
        setupUI()
        hideButton.frame = hideButtonFrame
        if hideButton.superview == nil {
            viewController?.baseView.addSubview(hideButton)
        }
    }
    
    @objc
    func hideButtonHandler(_ sender: RoundButton) {
        if isHidden {
            let alertController = UIAlertController(title: "Enter a Password", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.isSecureTextEntry = true
            }
            let saveAction = UIAlertAction(title: "Ok", style: .default, handler: { alert -> Void in
                let pass = alertController.textFields?[0].text ?? ""
                let email = Auth.auth().currentUser?.email ?? ""
                Auth.auth().signIn(withEmail: email, password: pass) { [weak alertController, weak self] (authResult, error) in
                    guard let alertController = alertController, let self = self else {
                        return
                    }
                    if error == nil {
                        alertController.dismiss(animated: true)
                        self.isHidden = false
                        self.setupUI()
                    } else {
                        (self.viewController as! UIViewController).present(alertController, animated: true, completion: {
                            alertController.textFields?[0].text = ""
                        })
                    }
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            (self.viewController as! UIViewController).present(alertController, animated: true, completion: {
                alertController.textFields?[0].becomeFirstResponder()
            })
        } else {
            isHidden = !isHidden
            setupUI()
        }
    }
    
    
    
    private func setupUI() {
        hideButton.alpha = 0
        
        let title = isHidden ? titleForHiddenState : titleForShownState
        hideButton.setTitle(title, for: .normal)
        
        let color = isHidden ? UIColor.green : UIColor.red
        hideButton.backgroundColor = color
        
        let alpha = isHidden ? 0 : 1
        
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.viewController?.targetView?.alpha = CGFloat(alpha)
            self?.hideButton.alpha = 1
        }) {[weak self] (result) in
            let hidden = self?.isHidden ?? true
            self?.viewController?.setupHideKeyboardTap(isActive: hidden)
        }
    }
}
