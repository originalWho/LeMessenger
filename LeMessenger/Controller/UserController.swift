//
//  UserController.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/11/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import UIKit

class UserController: NSObject {
    let messenger = Messenger.shared()
    let storage = Storage.shared
    
    static let shared : UserController = {
        let instance = UserController()
        return instance
    }()
    
    func requestUsers(completion: @escaping (OperationResult) -> Void) {
        messenger?.requestActiveUsers({ (result, userList) in
            switch result {
            case .Ok:
                let users : NSMutableArray = userList!
                self.storage.users = (users as NSArray) as! [User]
                for user in self.storage.users {
                    if self.storage.messages[user.userId] == nil {
                        self.storage.messages[user.userId] = [Message]()
                    }
                }
                break
            case .AuthError:
                break
            case .NetworkError:
                break
            case .InternalError:
                break
            }
            completion(result)
        })
    }
}
