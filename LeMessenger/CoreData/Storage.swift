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
    
}
