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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func connectAction(_ sender: AnyObject) {
        self.connectButton.isEnabled = false
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        //TODO: Check if empty
        
        let messenger = Messenger.shared()!
        messenger.login(withUserId: username, password: password) { (result) in
            switch result {
            case .Ok:
                performUIUpdatesOnMain {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "UsersNavigatorController") as! UINavigationController
                    self.present(controller, animated: true, completion: nil)
                }
            case .AuthError:
                self.connectButton.isEnabled = true
                break
            case .NetworkError:
                self.connectButton.isEnabled = true
                break
            case .InternalError:
                self.connectButton.isEnabled = true
                break
            //TODO: Show error message
            }
        }
    }
    
    
    @IBAction func disconnectAction(_ sender: AnyObject) {
        let messenger = Messenger.shared()!
        messenger.disconnect()
    }
    
}

