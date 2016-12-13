//
//  Storage.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/11/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import UIKit

class Storage : NSObject {
    
    var users = [User]()
    
    var messages = [String:[Message]]()
    
    var messageToUser = [String:String]()
    
    static let shared : Storage = {
        let instance = Storage()
        return instance
    }()
    
    /*
    func sortUsersByLastMessage() {
        users.sort { (user1, user2) -> Bool in
            let time1 = messages[user1.userId]?.last?.time
            let time2 = messages[user1.userId]?.last?.time
            return time1! > time2!
        }
    }
    */
}
