//
//  AuthController.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/11/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import UIKit

class AuthController: NSObject {

    let messenger = Messenger.shared()
    let encrypted = false
    
    static let shared : AuthController = {
        let instance = AuthController()
        return instance
    }()
    
    func login(username : String, password : String, completion : @escaping (_ result : OperationResult) -> Void) {
        let policy = SecurityPolicy.init()
        if encrypted {
            policy.encryptionAlgo = .RSA_1024
            //policy.encryptionPubKey =
        }
        messenger?.login(withUserId: username, password: password, securityPolicy: policy, completion: { (result) in
            completion(result)
        })
    }
}
