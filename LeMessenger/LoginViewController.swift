//
//  LoginViewController
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var connectButton: UIButton!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    let usernameMustNotBeEmptyWarning = "Username must not be empty"
    let passwordMustNotBeEmptyWarning = "Password must not be empty"
    let authErrorWarning = "Authentication error. Please retry"
    let networkErrorWarning = "Network error. Please retry"
    let internalErrorWarning = "Internal error. Please retry"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.isHidden = true
    }

    @IBAction func connectAction(_ sender: AnyObject) {
        connectButton.isEnabled = false
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        guard !username.isEmpty else {
            warningLabel.text = usernameMustNotBeEmptyWarning
            warningLabel.isHidden = false
            connectButton.isEnabled = true
            return
        }
        
        guard !password.isEmpty else {
            warningLabel.text = passwordMustNotBeEmptyWarning
            warningLabel.isHidden = false
            connectButton.isEnabled = true
            return
        }
        
        AuthController.shared.login(username: username, password: password) { (result) in
            switch result {
            case .Ok:
                performUIUpdatesOnMain {
                    MessageController.shared.subscribeToMessagesNotifications()
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "UsersNavigatorController") as! UINavigationController
                    self.present(controller, animated: true, completion: nil)
                }
            case .AuthError:
                self.connectButton.isEnabled = true
                self.warningLabel.text = self.authErrorWarning
                self.warningLabel.isHidden = false
                break
            case .NetworkError:
                self.connectButton.isEnabled = true
                self.warningLabel.text = self.networkErrorWarning
                self.warningLabel.isHidden = false
                break
            case .InternalError:
                self.connectButton.isEnabled = true
                self.warningLabel.text = self.internalErrorWarning
                self.warningLabel.isHidden = false
                break
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.warningLabel.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            connectAction(self)
        }
        return true
    }
}

